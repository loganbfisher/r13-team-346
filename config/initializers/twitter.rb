Twitter.configure do |config|
  config.consumer_key = ENV["TWITTER_PROVIDER_KEY"]
  config.consumer_secret = ENV["TWITTER_PROVIDER_SECRET"]
end