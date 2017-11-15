module Nrdb
  class Oauth
    def self.auth_uri
      URI("https://netrunnerdb.com/oauth/v2/auth").tap do |uri|
        uri.query = {
          client_id: Rails.application.secrets[:nrdb]["client_id"],
          redirect_uri: "#{Rails.application.secrets[:domain]}/oauth/callback",
          response_type: :code
        }.to_query
      end.to_s
    end

    def self.get_access_token(grant_code)
      JSON.parse(
        Faraday.get(grant_token_uri(grant_code)).body
      ).with_indifferent_access
    end

    private

    def self.grant_token_uri(code)
      URI("https://netrunnerdb.com/oauth/v2/token").tap do |uri|
        uri.query = {
          client_id: Rails.application.secrets[:nrdb]["client_id"],
          client_secret: Rails.application.secrets[:nrdb]["client_secret"],
          redirect_uri: "#{Rails.application.secrets[:domain]}/oauth/callback",
          grant_type: :authorization_code,
          code: code
        }.to_query
      end.to_s
    end

    # def self.refresh_token_uri(token)
    #   URI("https://netrunnerdb.com/oauth/v2/token").tap do |uri|
    #     uri.query = {
    #       client_id: Rails.application.secrets[:nrdb]["client_id"],
    #       client_secret: Rails.application.secrets[:nrdb]["client_secret"],
    #       grant_type: :refresh_token,
    #       refresh_token: token
    #     }.to_query
    #   end.to_s
    # end
  end
end
