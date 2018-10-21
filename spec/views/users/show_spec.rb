require 'rails_helper'

describe 'users/show' do
  let(:body_fixture) { file_fixture('api/spotify.com/v1/me/tracks.json').read }
  let(:query) { { limit: 20, offset: 0 } }
  let(:auth_params_fixture) do
    JSON.parse(file_fixture('/user/omniauth.json').read)
  end

  let!(:user) do
    create :user,
           email:        auth_params_fixture.dig('info', 'email'),
           spotify_auth: auth_params_fixture
  end

  before do
    stub_request(:get, "#{Api::Spotify::BASE_URI}/me/tracks")
      .with(query: query)
      .to_return(status:  200,
                 body:    body_fixture,
                 headers: Api::Spotify::HEADERS)
  end

  it do
    render template: 'users/show',
           locals:   User::Show.new(user: user).call

    expect(rendered).to include(user.email)
  end
end
