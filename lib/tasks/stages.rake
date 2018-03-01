namespace :stages do
  desc 'migrate stages'
  task migrate: :environment do
    # migrate all swiss tournaments
    Tournament.where(stage: :swiss).each do |tournament|
      if tournament.stages.empty?
        swiss = tournament.stages.create!(format: :swiss, number: 1)
        swiss.players = tournament.players
        tournament.rounds.update(stage: :swiss)
      end
    end

    Tournament.where(stage: :double_elim).each do |tournament|
      cut = tournament.previous.stages.create!(format: :double_elim)
      cut.players = tournament.players.map(&:previous)
      tournament.rounds.update(stage: :cut)
    end
  end
end
