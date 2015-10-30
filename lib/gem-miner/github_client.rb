require 'base64'
require 'octokit'

module GemMiner
  # A Github client with GemMiner-specific extensions.
  class GithubClient

    def initialize(github_access_token = nil)
      @internal_client = Octokit::Client.new(
        auto_paginate: true,
        access_token: github_access_token
      )
    end

    # Gets the files from a code search.
    def files(query)
      @internal_client.search_code(query)['items']
        .map do |item|
          {
            name: name_of(item),
            content: raw_content(item),
          }
        end
    end

    private

    def name_of(item)
      item[:repository][:full_name]
    end

    def raw_content(item)
      content_request = @internal_client.contents(name_of(item), path: item[:path])
      Base64.decode64 content_request[:content]
    end

  end
end
