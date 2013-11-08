class CommentsController < ApplicationController
  # POST /games
  # POST /games.json
  def create
    @comment = Comment.new(params[:comment])
    @comment.date_time = Time.now
    @comment.save
    game = Game.find(@comment.game_id)
    user = current_user
    game.comments.push(@comment)
    user.comments.push(@comment)
    @comments = game.comments.order_by([:date_time, :desc])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to game, notice: 'Comment posted successfully.' }
        format.json { render json: @comment, status: :created, location: @comment }
        format.js {@comments}
      else
        format.html { render "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js {@comments}
      end
    end
  end
end
