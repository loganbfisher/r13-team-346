class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  def index
    @comment = Comment.all.sort_by(&:date)
    @comment.each do |comment|
      if comment.admin
        user = User.where({'twitter_id' => comment.admin}).first
        comment.author_handle = user.handle
        comment.author_image = user.image
        comment.save
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comment }
      format.js { render :js => @comment }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /games/1/edit
  def edit
    session[:return_to] ||= request.referer
    @comment = Comment.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @comment = Comment.new(params[:comment])
    @game = Game.find(@comment.game_id)
    @comment.user_id = current_user.twitter_id
    @comment.author_handle = current_user.handle
    @comment.author_image = current_user.image
    @comment.date_time = Time.now
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @game, notice: 'Comment posted successfully.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:game])
        format.html { redirect_to session.delete(:return_to), notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
end
