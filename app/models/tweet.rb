module Tweet
  include Mongoid::Document

  field :tweet_id, type: Integer
  field :created_at, type: String
  field :coordinates, type: Array
  field :place, type: Array
  field :text, type: String
  field :user_id, type: Integer
  belongs_to :game
end