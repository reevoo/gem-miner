require 'gem-miner/cli'

describe GemMiner::CLI do

  let(:subject) { GemMiner::CLI }

  describe '#gems' do
    it 'calls GemMiner::Miner with the query specified' do
      expect(GemMiner::Miner).to receive(:gems_for)
        .with('user:reevoo', nil)

      subject.start(%w(gems user:reevoo))
    end
  end

  describe 'token option' do
    let(:valid_command) { %w(gems user:reevoo) }

    it 'is anonymous Github client by default' do
      expect(GemMiner::Miner).to receive(:gems_for)
        .with('user:reevoo', nil)

      subject.start(valid_command)
    end

    it 'passes Github token to GemMiner::Miner' do
      expect(GemMiner::Miner).to receive(:gems_for)
        .with('user:reevoo', 'token')

      subject.start(valid_command + %w(--token=token))
    end
  end

end
