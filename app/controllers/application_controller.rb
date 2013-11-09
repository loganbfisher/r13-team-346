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

  def joined_notification
    @notification = Notification.new(params[:notification])
    @notification.notifier_image = current_user.image
    @notification.notifier_handle = current_user.handle
    @notification.notifier_game = @game.name
    @notification.notifier_date_time = Time.now
    @notification.message = 'has joined your game '
    @notification.game_admin_id = @game.admin
    @notification.save
  end
end
