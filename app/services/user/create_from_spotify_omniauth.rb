class User::CreateFromSpotifyOmniauth
  attr_reader :auth_params

  def initialize(auth_params:)
    @auth_params = auth_params
  end

  def call
    ApplicationRecord.transaction do
      user.spotify_auth = auth_params
      user.save!
    end

    [:ok, user]
  end

  def user
    @user ||= User.where(email: email).first_or_create!
  end

  def email
    auth_params.dig('info', 'email').to_s.downcase
  end
end
