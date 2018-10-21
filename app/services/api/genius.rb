module Api
  module Genius
    module_function

    BASE_URI = 'https://genius.com/api'.freeze
    HEADERS  = {
      'Content-Type' => 'application/json'
    }.freeze

    def search_multi(q:, per_page: 5)
      HTTParty.get(
        BASE_URI + '/search/multi',
        query:   { q: q, per_page: per_page },
        headers: HEADERS
      )
    end
  end
end
