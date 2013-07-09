class User < ActiveRecord::Base
  validates :twitter_id, :uniqueness => true
end
