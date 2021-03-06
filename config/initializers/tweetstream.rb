TweetStream.configure do |config|
  config.consumer_key = ENV["TWITTER_PROVIDER_KEY"]
  config.consumer_secret = ENV["TWITTER_PROVIDER_SECRET"]
  config.oauth_token = ENV["TWITTER_OAUTH_KEY"]
  config.oauth_token_secret = ENV["TWITTER_OAUTH_SECRET"]
  config.auth_method        = :oauth
end