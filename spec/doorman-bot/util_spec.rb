# frozen_string_literal: true

require 'doorman-bot/util'

RSpec.describe DoormanBot::Util do
  before(:each) do
    stubbed_channels = Object.new
    allow(stubbed_channels).to receive(:channels).and_return([])
    allow(stubbed_channels).to receive(:groups).and_return([])
    allow_any_instance_of(Slack::Web::Client).to receive(:channels_list)
      .and_return(stubbed_channels)
    allow_any_instance_of(Slack::Web::Client).to receive(:groups_list)
      .and_return(stubbed_channels)
  end

  describe '#guest_lists' do
    # Hacky workaround so my mocking of Dir doesn't interfere with other tests.
    let(:mocked) { described_class.clone }

    it 'properly processes files' do
      expect(Dir).to receive(:entries).and_return(
        %w[. .. foo bar.yml a.yml cat.yml]
      )
      expect(mocked.instance.guest_lists).to eq(%w[a bar cat])
    end
  end

  describe '#get_target_names' do
    it 'completes successfully on all files' do
      all_lists = described_class.instance.guest_lists
      all_lists.each do |l|
        expect { described_class.instance.get_target_names(l) }
          .not_to raise_error
      end
    end
  end
end
