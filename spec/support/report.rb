module Report
  def report(round, number, p1, score1, p2, score2, side = nil)
    create(:pairing,
      round: round,
      player1: p1,
      player2: p2,
      score1: score1,
      score2: score2,
      table_number: number,
      side: side || :player1_is_corp
    )
  end
end
