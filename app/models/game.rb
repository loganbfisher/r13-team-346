class Game
  include Mongoid::Document

  field :name, type: String
  field :game_type, type: String
  field :location, type: String
  field :city, type: String
  field :state, type: String
  field :zip, type: String
  field :date, type: String
  field :time, type: String
  field :player_max, type: String
  field :equipment, type: String
  field :coordinates, type: Array
  field :place_id, type: Integer

  has_many :tweets
end