class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    if params['id'] == 'sign_out'
      reset_session
      redirect_to root_path
    else
      @user = User.find(params[:id])
    end
  end

end
