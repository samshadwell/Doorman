# frozen_string_literal: true

module DoormanBot
  module Commands
    # List command, fetches all groups known groups and sends to user.
    class Describe < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        client.say(
          channel: data.channel,
          text: "I'm sorry, you need to provide a guest list to describe. " \
                'For more information try `doorman help describe`',
          thread_ts: data.thread_ts || data.ts
        )
      end
    end
  end
end
