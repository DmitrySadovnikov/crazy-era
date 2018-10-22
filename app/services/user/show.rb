class User::Show
  attr_reader :user
  attr_reader :search_by_lyric

  def initialize(user:, search_by_lyric: nil)
    @user = user
    @search_by_lyric = search_by_lyric
  end

  def call
    {
      user: {
        id:           user.id,
        email:        user.email,
        saved_tracks: search_by_lyric ? tack_by_lyric : saved_tracks,
      }
    }
  end

  def track_presenter(track)
    {
      name:         track.name,
      href:         track.external_urls['spotify'],
      artist_names: track.artists.map(&:name),
      preview_url:  track.preview_url
    }
  end

  def saved_tracks
    user.spotify_user.saved_tracks.map { |track| track_presenter(track) }
  end

  def tack_by_lyric
    offset = 0

    10.times do |i|
      user.spotify_user.saved_tracks(limit: 50, offset: offset * (i + 1)).each do |track|
        if filtered_suggested_track_names.any? { |name| track.name.match?(/#{name}/i) }
          return [track_presenter(track)]
        end
      end
    end

    []
  end

  def genius_search
    @genius_search ||=
      Api::Genius.search_multi(q: search_by_lyric, per_page: 5)
  end

  def suggested_track_names
    lyric_section['hits'].map { |hit| hit.dig('result', 'title') }
  end

  def filtered_suggested_track_names
    @filtered_suggested_track_names ||=
      suggested_track_names.map { |name| name.match(/(.*)\s(\(.*\))/).try(:[], 1) || name }
  end

  def lyric_section
    genius_search.dig('response', 'sections').find do |section|
      section['type'] == 'lyric'
    end
  end
end
