# frozen_string_literal: true

module DoormanBot
  module Commands
    # Invite command, invites given user to a guest list.
    class Describe < SlackRubyBot::Commands::Base
      REGEX = /^(?<bot>\w*)\sinvite\s(?<user>\S*)\sto\s(?<list>\S*)/

      match(REGEX) do |client, data, match|
        user = match['user']
        list = match['list']

        if valid_user?(user)
          user_id = user[2..-2]
          res = DoormanBot::Util.instance.invite_to_list(
            data.user, user_id, list
          )

          response_text = "res: #{res}"
        else
          response_text = DoormanBot::INVALID_USER_RESPONSE
        end
        respond_in_thread client, data, response_text
      end

      private

      def self.valid_user?(user)
        /<@U\S+>/ === user
      end
    end
  end
end
