require 'csv'

module Import
  class CSV_Import
    attr_reader :csv_content

    def initialize(csv_file)
      @csv_content = CSV.parse(csv_file.read)
    end

    def apply(tournament)
      Tournament.transaction do
        tournament.stages.destroy_all
        tournament.players.destroy_all

        csv_content.each do |player_name, corp_id, runner_id|
          player = tournament.players.create!(
            name: player_name,
            corp_identity: Identity.guess(corp_id)&.name,
            runner_identity: Identity.guess(runner_id)&.name,
            seed: nil,
            first_round_bye: false,
            active: true
          )
        end
      end
    end

  end
end
