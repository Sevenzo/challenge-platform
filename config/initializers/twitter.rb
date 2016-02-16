TWITTER_CONFIG = {
  consumer_key:         ENV.fetch('TWITTER_CONSUMER_KEY'),
  consumer_secret:      ENV.fetch('TWITTER_CONSUMER_SECRET'),
  access_token:         ENV.fetch('TWITTER_ACCESS_TOKEN'),
  access_token_secret:  ENV.fetch('TWITTER_ACCESS_SECRET')
}

# twitter_rest_client = Twitter::REST::Client.new(TWITTER_CONFIG)
