module PairingSorters
  class Ranked
    def self.sort(pairings)
      pairings.sort do |a, b|
        b.players.sum(&:points) <=> a.players.sum(&:points)
      end
    end
  end
end
