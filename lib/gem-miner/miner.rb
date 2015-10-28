require 'base64'
require 'octokit'

require 'gem-miner/github_client'

module GemMiner
  class Miner

    def self.gems_for(*args)
      new(*args).gems
    end

    def initialize(github_search_query, github_client = GithubClient.new, logger = STDOUT)
      @github_search_query = github_search_query
      @github_client = github_client
      @logger = logger
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
      gemfiles = parse_gemfiles
      gemspecs = parse_gemspecs

      gems = merge_hashes(gemfiles, gemspecs)

      # Invert the PROJECT => [GEMS] hash to a GEM => [PROJECTS] hash
      gems = invert_hash_of_arrays(gems)

      # Sort it
      gems = gems.sort.to_h
    end

    # Collects all of the gemfiles for all Reevoo repositories.
    # Returns a dictionary with the gem as the key and an array of repositories as
    # values.
    def parse_gemfiles
      results = search("filename:Gemfile #{@github_search_query}")
      log "Parsing #{results.count} gemfiles"
      gemfiles = results.reduce({}) do |memo, result|
        # We might have more than one Gemfile in a repository...
        memo[name_of(result)] ||= []
        memo[name_of(result)] += extract_gemfile(result[:content])
        log '.'
        memo
      end
      log "done!\n"
      gemfiles
    end

    GEM_REGEX = /gem[\s]+([^\n\;]+)/
    def extract_gemfile(gemfile)
      gemfile.gsub(/\"/, '\'').scan(GEM_REGEX).flatten
    end

    def parse_gemspecs
      results = search("filename:gemspec #{@github_search_query}")
      log "Parsing #{results.count} gemspecs"
      gemspecs = results.reduce({}) do |memo, result|
        # We might have more than one Gemfile in a repository...
        memo[name_of(result)] ||= []
        memo[name_of(result)] += extract_gemspec(result[:content])
        log '.'
        memo
      end
      log "done!\n"
      gemspecs
    end

    GEMSPEC_REGEX = /dependency[\s]+([^\n\;]+)/
    def extract_gemspec(gemspec)
      gemspec.gsub(/\"/, '\'').scan(GEMSPEC_REGEX).flatten
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
    # From http://stackoverflow.com/questions/11171834/merging-ruby-hash-with-array-of-values-into-another-hash-with-array-of-values
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

    def log(s)
      @logger.print s if @logger
    end
  end
end
