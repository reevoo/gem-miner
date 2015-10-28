require 'gem-miner/miner'

describe GemMiner::Miner do
  describe '#gems' do

    it 'requests gemfiles and gemspecs from Github for the provided query' do
      subject = described_class.new('QUERY', nil, nil) # disable logging

      expect(subject.github_client).to receive(:search_code)
        .with('filename:Gemfile QUERY')
        .and_return({ 'items' => [] })

      expect(subject.github_client).to receive(:search_code)
        .with('filename:gemspec QUERY')
        .and_return({ 'items' => [] })

      subject.gems
    end

    # TODO: This is hard to write, so we need to refactor.
    it 'returns gem information as a gem => [repos] hash' do
    end

  end

  describe 'logging' do

    it 'prints to STDOUT by default' do
      subject = described_class.new('QUERY')
      allow(subject.github_client).to receive(:search_code)
        .and_return({ 'items' => [] })

      expect(STDOUT).to receive(:print).at_least(:once)
      subject.gems
    end

    it 'can be turned off' do
      subject = described_class.new('QUERY', nil, nil)
      allow(subject.github_client).to receive(:search_code)
        .and_return({ 'items' => [] })

      expect(STDOUT).not_to receive(:print)
      subject.gems
    end

  end

end
