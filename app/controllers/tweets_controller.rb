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
end