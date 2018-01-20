namespace :ids do
  desc 'update identities'
  task update: :environment do
    Nrdb::Connection.new
      .cards
      .select { |card| card[:type_code] == "identity" }
      .each do |id|
        Identity.find_or_create_by(nrdb_code: id[:code])
          .update(
            name: id[:title],
            side: id[:side_code],
            faction: id[:faction_code],
            autocomplete: id[:title]
          )
      end

      Identity.where(nrdb_code: '10030').update(
        autocomplete: 'Palana Foods: Sustainable Growth'
      )
      Identity.where(nrdb_code: ['02046', '20037']).update(
        autocomplete: 'Chaos Theory: Wunderkind'
      )
  end
end
