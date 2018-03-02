namespace :stages do
  desc 'migrate stages'
  task migrate: :environment do
    ActiveRecord::Base.transaction do
      # migrate all swiss tournaments
      puts 'Migrating swiss tournaments'
      Tournament.where(stage: :swiss).each do |tournament|
        if tournament.stages.empty?
          puts "Migrating tournament #{tournament.id}"
          puts 'Creating swiss stage'
          swiss = tournament.stages.create!(format: :swiss, number: 1)
          puts 'Moving players'
          swiss.players = tournament.players
          puts 'Moving rounds'
          Round.where(tournament: tournament).update_all(stage_id: swiss.id, tournament_id: nil)
          puts 'Done'
        end
      end
      puts "Finished swiss\n\n"

      puts 'Migrating cut tournaments'
      Tournament.where(stage: :double_elim).each do |tournament|
        puts "Migrating tournament #{tournament.id}"
        puts "Previous was: #{tournament.previous_id}"
        previous = Tournament.find(tournament.previous_id)
        puts 'Creating cut stage'
        cut = previous.stages.create!(format: :double_elim)
        puts 'Moving players'
        tournament.players.each do |player|
          cut.registrations.create!(player: player, seed: player.seed)
          player.update!(tournament: previous, seed: nil)
        end
        puts 'Moving rounds'
        Round.where(tournament: tournament).update_all(stage_id: cut.id, tournament_id: nil)
        puts 'Destroying old tournament'
        tournament.reload.destroy
        puts 'Done'
      end
      puts "Finished cut\n\n"

      puts 'Cleaning erroneous tournaments'
      Tournament.all.select { |t| t.stages.count > 2 }.each do |tournament|
        puts "Cleaning tournament #{tournament.id}"
        tournament.stages.select { |s| s.rounds.count == 0 }.each do |stage|
          puts "Destroying stage #{stage.id}"
          stage.destroy!
        end
      end
      puts 'Finished'
    end
  end
end
