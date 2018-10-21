require 'rails_helper'

describe Api::Genius do
  context 'search_multi' do
    subject { described_class.search_multi(query) }

    let(:query) { { q: 'скр скр', per_page: 5 } }
    let(:body_fixture) { file_fixture('/api/genius.com/search/multi.json').read }

    before do
      stub_request(:any, Api::Genius::BASE_URI + '/search/multi')
        .with(query: query)
        .to_return(status: 200, body: body_fixture, headers: Api::Genius::HEADERS)
    end

    it do
      expect(subject).to be_a(HTTParty::Response)
      expect(subject.dig('meta', 'status')).to eq(200)
    end
  end
end
