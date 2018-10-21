class User::Show
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    {
      user: {
        email:        user.email,
        saved_tracks: saved_tracks,
      }
    }.as_json
  end

  def saved_tracks
    user.spotify_user.saved_tracks.map do |track|
      {
        name:         track.name,
        href:         track.external_urls['spotify'],
        artist_names: track.artists.map(&:name)
      }
    end
  end
end
