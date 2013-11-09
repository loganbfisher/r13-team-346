class ApplicationController < ActionController::Base
  protect_from_forgery

  def getTwitterClient
    if current_user
      token = session[:token]
      secret = session[:secret]
    else
      token = ENV["TWITTER_OAUTH_KEY"]
      secret = ENV["TWITTER_OAUTH_SECRET"]
    end
    Twitter::Client.new(
      :oauth_token => token,
      :oauth_token_secret => secret
    )
  end

end
