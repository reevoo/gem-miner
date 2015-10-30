require 'gem-miner/github_client'

describe GemMiner::GithubClient do

  let(:client) { double(:client) }

  before do
    allow(Octokit::Client).to receive(:new)
      .and_return(client)
  end

  describe '#initialize' do

    it 'adds auto-pagination to the client' do
      expect(Octokit::Client).to receive(:new)
        .with(hash_including(auto_paginate: true))

      described_class.new
    end

    it 'sets the access token' do
      expect(Octokit::Client).to receive(:new)
        .with(hash_including(access_token: 'TOKEN'))

      described_class.new 'TOKEN'
    end

  end

  describe '#files' do

    let(:subject) { described_class.new }
    let(:result) do
      {
        repository: { full_name: 'NAME' },
        path: 'PATH'
      }
    end

    let(:content) { Base64.encode64('CONTENT') }

    it 'queries the internal client' do
      expect(client).to receive(:search_code)
        .with('QUERY')
        .and_return('items' => [])

      subject.files('QUERY')
    end

    it 'queries content for each search result' do
      expect(client).to receive(:search_code)
        .with('QUERY')
        .and_return('items' => [result])

      expect(client).to receive(:contents)
        .with('NAME', path: 'PATH')
        .and_return(content: content)

      subject.files('QUERY')
    end

    it 'returns a name/content pair for each result' do
      expect(client).to receive(:search_code)
        .with('QUERY')
        .and_return('items' => [result])

      expect(client).to receive(:contents)
        .with('NAME', path: 'PATH')
        .and_return(content: content)

      expect(subject.files('QUERY')).to eq [{name: 'NAME', content: 'CONTENT'}]
    end

  end

end
