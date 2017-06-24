class AbrUpload
  attr_reader :tournament

  def initialize(tournament)
    @tournament = tournament
  end

  def upload!
    JSON.parse(send_data).with_indifferent_access
  end

  def self.upload!(tournament)
    new(tournament).upload!
  end

  private

  def send_data
    Faraday.new do |conn|
      conn.request :multipart
      conn.adapter :net_http
      conn.basic_auth 'cobra', Rails.application.secrets.abr_auth
    end.post endpoint do |req|
      upload = Faraday::UploadIO.new(StringIO.new(json), 'text/json')
      req.body = { jsonresults: upload }
    end.body
  end

  def endpoint
    "#{Rails.configuration.abr_host}/api/nrtm"
  end

  def json
    NrtmJson.new(tournament).data.to_json
  end
end
