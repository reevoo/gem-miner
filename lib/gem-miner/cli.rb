require 'gem-miner'
require 'thor'
require 'yaml'

module GemMiner
  class CLI < Thor

    option :token,
      aliases: [:t],
      desc: 'The Github access token to use when querying Github.',
      type: :string

    desc 'gems QUERY', 'Collects all gems for projects given by the Github query.'
    long_desc <<-LD
      Collects all gems for projects given by the Github query.
      This is useful for auditing which gems you use across all projects,
      to check whether you can delete any!

      The following command gets all gems for the organisation 'reevoo':

      > $ gem-miner gems user:reevoo

      You probably want to supply an access token to ensure you are not rate-limited
      by Github.

      This action returns the gems as a hash in YAML format with the gem description as the key
      and the repositories that use the gem as an array of values.
    LD
    def gems(github_search_query)
      puts GemMiner::Miner.gems_for(github_search_query, options[:token]).to_yaml
    end

  end
end
