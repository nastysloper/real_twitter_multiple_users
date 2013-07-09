class User < ActiveRecord::Base
  validates :twitter_id, :uniqueness => true

  def twitter_client
    @twitter_client ||= Twitter::Client.new(
        :oauth_token => self.token,
        :oauth_secret => self.secret
      )
  end
end
