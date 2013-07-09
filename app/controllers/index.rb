require 'twitter'

get '/' do
  if current_user
    @recent_tweets = twitter_client(current_user.oauth_token, current_user.oauth_secret).home_timeline
  end
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  # at this point in the code is where you'll need to create your user account and store the access token
  user = User.find_or_create_by_twitter_id(@access_token.params[:user_id])
  user.update_attributes!(username: @access_token.params[:screen_name],oauth_token: @access_token.token, oauth_secret: @access_token.secret)
  session[:user] = user.id
  erb :index
end

post '/tweet' do
  user = User.find(session[:user])
  client = twitter_client(user.oauth_token, user.oauth_secret)
  client.update(params[:tweet])
  
  200
end


def twitter_client(token, secret)
  Twitter::Client.new(
    :oauth_token => token,
    :oauth_token_secret => secret
  )
end
