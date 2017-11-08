RSpec.describe Nrdb::Oauth do
  describe '.auth_uri' do
    it 'generates correct URI' do
      expect(described_class.auth_uri).to eq(
        'https://netrunnerdb.com/oauth/v2/auth?client_id=test_id&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Foauth%2Fcallback&response_type=code'
      )
    end
  end

  describe '.get_access_token' do
    it 'fetches access token' do
      VCR.use_cassette :nrdb_get_access_token do
        expect(described_class.get_access_token('123')).to eq({
          "access_token" => "some_token",
          "expires_in" => 3600,
          "refresh_token" => "some_refresh_token",
          "scope" => nil,
          "token_type" => "bearer"
        })
      end
    end
  end
end
