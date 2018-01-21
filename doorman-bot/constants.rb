# frozen_string_literal: true

module DoormanBot
  # Directory where all the guest lists are.
  GUESTS_DIRECTORY = 'guest-lists'

  # Below are all constants used for message generation.
  LIST_LINE_BEGIN = ' • '

  MISSING_LIST_RESPONSE =
    "I'm sorry, you need to provide a guest list to describe. For more " \
    'information try `doorman help describe`'

  INVALID_LIST_RESPONSE =
    "It looks like the list you're trying to describe doesn't exist."

  INVALID_USER_RESPONSE =
    "I'm sorry, that doesn't appear to be a valid user. Be sure to tag them " \
    "in your message."
end
