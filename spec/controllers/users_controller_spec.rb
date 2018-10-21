require 'rails_helper'

describe UsersController do
  let(:auth_params_fixture) do
    JSON.parse(file_fixture('/user/omniauth.json').read)
  end

  context 'spotify' do
    subject do
      request.env['omniauth.auth'] = auth_params_fixture
      get :spotify
    end

    it do
      subject
      expect(response.code).to eq '302'
    end
  end

  context 'index' do
    subject { get :index }

    it do
      subject
      expect(response).to render_template(:index)
    end
  end

  context 'show' do
    context 'when current user present' do
      subject do
        get :show, params: params
      end

      let!(:user) do
        create :user,
               email:        auth_params_fixture.dig('info', 'email'),
               spotify_auth: auth_params_fixture
      end

      let(:params) { { id: user.id } }

      context 'when no tacks' do
        let(:body_fixture) { file_fixture('api/spotify.com/v1/me/tracks.json').read }
        let(:query) { { limit: 20, offset: 0 } }

        before do
          stub_request(:get, "#{Api::Spotify::BASE_URI}/me/tracks")
            .with(query: query)
            .to_return(status:  200,
                       body:    body_fixture,
                       headers: Api::Spotify::HEADERS)
        end

        it do
          subject
          expect(response).to render_template(:show)
        end
      end
    end
  end
end
