class Tweet
  include Mongoid::Document

  field :tweet_id, type: Integer
  field :created_at, type: String
  field :coordinates, type: Array
  field :place, type: Array
  field :text, type: String
  field :user_id, type: Integer
  field :game_id, type: Integer
  field :author, type: Integer
  field :author_handle, type: String

  belongs_to :game
  belongs_to :user
end