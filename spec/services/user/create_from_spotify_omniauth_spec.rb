require 'rails_helper'

describe User::CreateFromSpotifyOmniauth do
  context 'success' do
    subject { described_class.new(auth_params: auth_params_fixture).call }

    let(:auth_params_fixture) do
      JSON.parse(file_fixture('/user/omniauth.json').read)
    end

    context 'when no user' do
      it do
        expect { subject }.to change(User, :count).by(1)
        user = User.last
        expect(user.email).to be
        expect(user.session_token).to be
        expect(user.spotify_token).to be
      end
    end

    context 'when user exists' do
      let!(:user) do
        create :user, email: auth_params_fixture.dig('info', 'email')
      end

      it do
        expect { subject }.not_to change(User, :count)
        expect(user.reload.email).to be
        expect(user.spotify_auth).to eq(auth_params_fixture)
        expect(user.spotify_token).to eq(auth_params_fixture.dig('credentials', 'token'))
      end
    end
  end
end
