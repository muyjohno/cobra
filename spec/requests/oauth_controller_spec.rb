RSpec.describe OauthController do
  describe '#auth' do
    it 'redirects to NRDB' do
      get login_path

      expect(response).to be_redirect
      expect(response.location).to eq('https://netrunnerdb.com/oauth/v2/auth?client_id=test_id&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Foauth%2Fcallback&response_type=code')
    end
  end

  describe '#callback' do
    let(:make_request) { get oauth_callback_path, params: { code: :some_code } }
    let(:token_data) { { access_token: 'ABC123', refresh_token: 'DEF456' } }
    let(:connection) do
      double('Nrdb::Connection', player_info: [{ id: 12, username: 'jack' }])
    end

    before do
      allow(Nrdb::Oauth).to receive(:get_access_token)
        .with('some_code')
        .and_return(token_data)
      allow(Nrdb::Connection).to receive(:new)
        .with(nil, 'ABC123')
        .and_return(connection)
    end

    context 'when user is new' do
      it 'creates a user' do
        expect do
          make_request
        end.to change(User, :count).by(1)
      end

      it 'populates new user' do
        make_request

        expect(User.find_by(nrdb_id: 12).nrdb_username).to eq('jack')
      end
    end

    context 'when user exists' do
      let!(:user) { create(:user, nrdb_id: 12, nrdb_username: 'jill') }

      it 'does not create a user' do
        expect do
          make_request
        end.not_to change(User, :count)
      end

      it 'updates user details' do
        make_request

        expect(User.find_by(nrdb_id: 12).nrdb_username).to eq('jack')
      end
    end
  end
end
