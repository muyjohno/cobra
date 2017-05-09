class AbrUpload
  attr_reader :tournament, :standings

  def initialize(tournament)
    @tournament = tournament
    @standings = tournament.standings
  end

  def upload!
    JSON.parse(send_data).with_indifferent_access
  end

  def self.upload!(tournament)
    new(tournament).upload!
  end

  def data
    {
      name: tournament.name,
      cutToTop: 0,
      players: standings.each_with_index.map do |standing, i|
        {
          corpIdentity: standing.corp_identity,
          runnerIdentity: standing.runner_identity,
          rank: i+1,
          id: standing.player.id,
          name: standing.name,
        }
      end
    }
  end

  private

  def send_data
    Faraday.new do |conn|
      conn.request :multipart
      conn.adapter :net_http
      conn.basic_auth 'cobra', Rails.application.secrets.abr_auth
    end.post endpoint do |req|
      upload = Faraday::UploadIO.new(StringIO.new(data.to_json), 'text/json')
      req.body = { jsonresults: upload }
    end.body
  end

  def endpoint
    "#{Rails.configuration.abr_host}/api/nrtm"
  end
end
