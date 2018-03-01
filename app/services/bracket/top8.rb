module Bracket
  class Top8 < Base
    game 1, seed(1), seed(8), round: 1
    game 2, seed(4), seed(5), round: 1
    game 3, seed(2), seed(7), round: 1
    game 4, seed(3), seed(6), round: 1

    game 5, winner(1), winner(2), round: 2
    game 6, winner(3), winner(4), round: 2
    game 7, loser(1), loser(2), round: 2
    game 8, loser(3), loser(4), round: 2

    game 9, winner(5), winner(6), round: 3
    game 10, loser(6), winner(7), round: 3
    game 11, winner(8), loser(5), round: 3

    game 12, winner(10), winner(11), round: 4

    game 13, loser(9), winner(12), round: 5

    game 14, winner(9), winner(13), round: 6

    game 15, winner(14), loser(14), round: 7

    STANDINGS = [
      [winner(15), winner_if_also_winner(14, 9)],
      [loser(15), loser_if_also_winner(14, 13)],
      loser(13),
      loser(12),
      seed_of([loser(10), loser(11)], 1),
      seed_of([loser(10), loser(11)], 2),
      seed_of([loser(7), loser(8)], 1),
      seed_of([loser(7), loser(8)], 2)
    ]
  end
end
