require 'base64'
require 'octokit'

require 'gem-miner/github_client'
require 'gem-miner/logger'

module GemMiner
  class Miner
    include Logger

    GEMFILE_REGEX = /gem[\s]+([^\n\;]+)/
    GEMSPEC_REGEX = /dependency[\s]+([^\n\;]+)/

    def self.gems_for(*args)
      new(*args).gems
    end

    def initialize(github_search_query, github_client = GithubClient.new)
      @github_search_query = github_search_query
      @github_client = github_client
    end

    # A hash of gems and the repositories they are used in:
    #
    # {
    #   "pry '~> 1'" => ['reevoo/flakes', 'reevoo/gem-miner'],
    #   ...
    # }
    def gems
      @gems ||= collect_gems!
    end

    private

    # Collects gem specifications from Gemfiles and Gemspecs.
    # Returns a hash of gems and the repositories they are used in:
    #
    # {
    #   "pry '~> 1'" => ['reevoo/flakes', 'reevoo/gem-miner'],
    #   ...
    # }
    def collect_gems!
      gemfiles = parse_sources('Gemfile', GEMFILE_REGEX)
      gemspecs = parse_sources('gemspec', GEMSPEC_REGEX)

      gems = merge_hashes(gemfiles, gemspecs)

      # Invert the PROJECT => [GEMS] hash to a GEM => [PROJECTS] hash
      gems = invert_hash_of_arrays(gems)

      # Sort it
      gems = gems.sort.to_h
    end

    # Collects all of the gemfiles for all Reevoo repositories.
    # Returns a dictionary with the gem as the key and an array of repositories
    # as values.
    def parse_sources(filename, regex)
      results = search("filename:#{filename} #{@github_search_query}")
      log "Parsing #{results.count} #{filename}s"
      files = results.reduce({}) do |memo, result|
        # We might have more than one dep file in a repository...
        memo[name_of(result)] ||= []
        memo[name_of(result)] += extract_deps(result[:content], regex)
        log '.'
        memo
      end
      log "done!\n"
      files
    end

    def extract_deps(file, regex)
      file.gsub(/\"/, '\'').scan(regex).flatten
    end

    def search(query)
      @github_client.files(query)
    end

    # Merge two hashes of lists
    #
    # h1 = { a: [1, 2, 3], b: [2, 4] }
    # h2 = { b: [1, 3], c: [1, 2, 3] }
    # merge_hashes(h1, h2) # => { a: [1, 2, 3], b: [1, 2, 3, 4], c: [1, 2, 3] }
    #
    # From http://stackoverflow.com/questions/11171834
    def merge_hashes(hash1, hash2)
      hash1.merge(hash2) { |key, oldval, newval| (oldval | newval) }
    end

    # Converts a hash of the form A => [Bs] to B => [As]
    def invert_hash_of_arrays(hash)
      hash.reduce({}) do |memo, (key, values)|
        values.each do |v|
          memo[v] ||= []
          memo[v] << key
        end

        memo
      end
    end
  end
end
