class User < ApplicationRecord
  store_accessor :data,
                 :spotify_auth

  def spotify_token
    spotify_auth.dig('credentials', 'token')
  end

  def spotify_user
    RSpotify::User.new(spotify_auth)
  end
end
