class TweetsController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    @tweets = Tweet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tweets }
    end
  end

  def get_new_tweets
    client = getTwitterClient
    coordinates = Geocoder.coordinates(params[:filter])
    tweets = client.search('pick up game', :geocode => coordinates[0] + ',' + coordinates[1] + ',' + ',30m', :count => 100).results if coordinates
    tweets = client.search('pick up game', :count => 100).results
    tweets.each do |tweet|
      params = {:tweet_id => tweet.id, :text => tweet.text, :created_at => tweet.created_at, :author => tweet.user[:id], :author_handle => tweet.user[:screen_name]}
      @tweet = Tweet.new(params)
      @tweet.save
    end
    redirect_to @tweets
  end

  def filter
    client = getTwitterClient
    @filter = params[:tweets_filter][:zip] ? params[:tweets_filter][:zip] : nil
    coordinates = Geocoder.coordinates(@filter)
    tweets = client.search('pick up game', :geocode => coordinates[0].to_s + ',' + coordinates[1].to_s + ',' + ',30m', :count => 100).results if coordinates
    tweets = [] if tweets.nil?
    tweets.each do |tweet|
      params = {:tweet_id => tweet.id, :text => tweet.text, :created_at => tweet.created_at, :author => tweet.user[:id], :author_handle => tweet.user[:screen_name]}
      @tweet = Tweet.new(params)
      @tweet.save
    end
    all_tweets = Tweet.all
    tweets = []

    all_tweets.each do |tweet|
      if coordinates
        distance = Geocoder::Calculations.distance_between(coordinates, tweet.coordinates)
        if distance <= 30
          tweets << tweet.id
        end
      end
    end
    @tweets = Tweet.all_in(:id => tweets)
    @tweets = all_tweets if @filter.nil? || @filter == ''

    render :index
  end
end