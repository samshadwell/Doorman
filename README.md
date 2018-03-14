## Doorman Bot
A failed exercise in trying to make multi-channel Slack invitations easier.

The goal of this project was to ease the Slack onboarding process by providing
users the ability to invite new users to an entire set of channels at once.

The goal was for users to be able to say `doorman invite @<user> to <list>`
and the bot would do the work of inviting that user to all channels included
by the list. The "guest lists" are declared as YAML, and even feature
inheritance.

Unfortunately, I got most of the way through this project (read: to the very,
very last step) before realizing that Slack doesn't allow bots to send 
invitations. Oh well. I should probably delete this repo, but I'm too
reluctant to admit total defeat, so instead this will live on in an 
almost-working-but-not-quite state forever.

