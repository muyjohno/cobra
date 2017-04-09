class Pairing < ApplicationRecord
  belongs_to :round
  belongs_to :player1, class_name: 'Player', optional: true
  belongs_to :player2, class_name: 'Player', optional: true

  def players
    [player1, player2]
  end
end
