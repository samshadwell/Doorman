# frozen_string_literal: true

module SlackRubyBot
  module Commands
    # Monkeypatch the base Command to provide a function for replying in-thread.
    class Base
      def self.respond_in_thread(client, data, text)
        client.say(channel: data.channel,
                   text: text,
                   thread_ts: data.thread_ts || data.ts)
      end
    end
  end
end
