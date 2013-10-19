class Game
  include Mongoid::Document

  field :name, type: String
  field :game_type, type: String
  field :location, type: String
  field :city, type: String
  field :state, type: String
  field :zip, type: String
  field :date, type: Date
  field :time, type: Time
  field :player_max, type: String
  field :equipment, type: String

  has_many :tweets
end