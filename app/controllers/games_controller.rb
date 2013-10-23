class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    @games = Game.all.sort_by(&:date)

    @games.each do |game|

      if game.admin
        user = User.where({'twitter_id' => game.admin}).first
        game.author_handle = user.handle
        game.author_image = user.image
        game.save
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    if @game.admin
      @user = User.where({ 'twitter_id' => @game.admin }).first
    end
    @users = @game.users
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])
    if @game[:location] || @game[:city] || @game[:state]
      location_string = @game[:location] if @game[:location]
      location_string += @game[:city] if @game[:city]
      location_string += @game[:state] if @game[:state]
      coordinates = Geocoder.coordinates(location_string)
      @game.coordinates = coordinates unless coordinates.nil?
    end
    if @game[:game_type]
      @game.tweet_text = 'Want to play some ' + @game[:game_type] + '? Meet me at ' + @game[:location] + ', ' + @game[:time] + ' on ' + @game[:date]
    end
    if current_user
      @game.admin = @current_user.twitter_id
    end
    respond_to do |format|
      if @game.save
        add_user_to_game
        @game.admin = current_user.twitter_id
        @game.save
        if ENV["TWITTER_POSTS_ENABLED"] == "TRUE"
          twitter = getTwitterClient
          game = params[:game]
          lat = @game.coordinates ? nil : coordinates[0]
          long = game.coordinates ? nil : coordinates[1]
          text = @game.tweet_text
          tweet = twitter.update(text, {:lat => lat, :long => long})
          @game.tweet_id = tweet[:id]
          @current_user.tweet_id = tweet[:id]
          @game.save
        end
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  def join
    if current_user
      @game = Game.find(params[:id])
      respond_to do |format|
        if add_user_to_game
          format.html { redirect_to @game, notice: 'Joined game.'}
          format.json { head :no_content}
        else
          format.html { redirect_to @game, notice: 'Unable to join game.'}
          format.json { head :no_content}
        end
      end
    else
      session["user_return_to"] = request.url
      redirect_to '/auth/twitter'
    end
  end

  def leave
    if current_user
      @game = Game.find(params[:id])
      respond_to do |format|
        if remove_user_from_game
          format.html { redirect_to @game, notice: 'Left game.'}
          format.json { head :no_content}
        else
          format.html { redirect_to @game, notice: 'You have to go to the game brah.'}
          format.json { head :no_content}
        end
      end
    end
  end

  def admin
    @game = Game.find(params[:id])
    @game.admin = current_user.twitter_id
    @game.save
    redirect_to games_url
  end

  def filter
    @filter = params[:games_filter][:zip] ? params[:games_filter][:zip] : nil
    coordinates = Geocoder.coordinates(@filter)
    all_games = Game.all
    games = []

    all_games.each do |game|
      if coordinates
        distance = Geocoder::Calculations.distance_between(coordinates, game.coordinates)
        if distance <= 30
          games << game.id
        end
      end
    end
    @games = Game.all_in(:id => games)
    @games = all_games if @filter.nil? || @filter == ''

    render :index
  end

  private
  def add_user_to_game
    @game.users.push(@current_user)
  end

  def remove_user_from_game
    @game.users.delete(@current_user)
  end
end
