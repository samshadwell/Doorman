require 'doorman-bot/util'

RSpec.describe DoormanBot::Util do
  describe '#guest_lists' do
    it 'properly processes files' do
      expect(Dir).to receive(:entries).and_return([
        '.',
        '..',
        'foo',
        'bar.yml',
        'a.yml',
        'cat.yml',
      ])
      expect(described_class.instance.guest_lists).to eq(['a', 'bar', 'cat'])
    end
  end
end
