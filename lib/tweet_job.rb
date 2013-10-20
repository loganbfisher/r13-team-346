class TweetJob
  @queue = :low

  def self.perform(value)
    TweetStream::Client.new.track('pick', 'up', 'games', '#pickupgames') do |tweet|
      params = {:tweet_id => tweet.id, :text => tweet.text, :created_at => tweet.created_at, :author => tweet.user[:id], :author_handle => tweet.user[:screen_name]}
      @tweet = Tweet.new(params)
      @tweet.save
    end
  end
end
