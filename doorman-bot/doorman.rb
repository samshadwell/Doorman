# frozen_string_literal: true

module DoormanBot
  # Base SlackBot.
  class Doorman < SlackRubyBot::Bot
    # TODO: override default help to reply in-thread.
    help do
      title 'Doorman'
      desc 'Simplifies multi-channel invitations.'

      command 'list' do
        desc 'Lists all available "guest lists" a user can be invited to.'
        long_desc 'Command format: doorman list'
      end

      command 'describe' do
        desc 'Lists all the channels included in the given guest list.'
        long_desc 'Command format: doorman describe <guest list>'
      end
    end
  end
end
