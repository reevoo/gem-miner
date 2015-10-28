require 'gem-miner/miner'

describe GemMiner::Miner do

  let(:client) { double(:client) }

  describe '#gems' do

    it 'requests gemfiles and gemspecs from Github for the provided query' do
      subject = described_class.new('QUERY', client, nil) # disable logging

      expect(client).to receive(:files)
        .with('filename:Gemfile QUERY')
        .and_return([])

      expect(client).to receive(:files)
        .with('filename:gemspec QUERY')
        .and_return([])

      subject.gems
    end

    # TODO: This is hard to write, so we need to refactor.
    it 'returns gem information as a gem => [repos] hash' do
    end

  end

  describe 'logging' do

    it 'prints to STDOUT by default' do
      subject = described_class.new('QUERY', client)
      allow(client).to receive(:files)
        .and_return([])

      expect(STDOUT).to receive(:print).at_least(:once)
      subject.gems
    end

    it 'can be turned off' do
      subject = described_class.new('QUERY', client, nil)
      allow(client).to receive(:files)
        .and_return([])

      expect(STDOUT).not_to receive(:print)
      subject.gems
    end

  end

end
