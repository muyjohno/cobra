module Bracket
  class Top4 < Base
    game 1, seed(1), seed(4), round: 1
    game 2, seed(2), seed(3), round: 1

    game 3, winner(1), winner(2), round: 2
    game 4, loser(1), loser(2), round: 2

    game 5, loser(3), winner(4), round: 3

    game 6, winner(3), winner(5), round: 4

    game 7, winner(6), loser(6), round: 5

    STANDINGS = [
      [winner(7), winner(6)],
      [loser(7), loser(6)],
      loser(5),
      loser(4)
    ]
  end
end
