class Round < ApplicationRecord
  belongs_to :tournament
  has_many :pairings

  def pair!
    Pairer.new(self).pair!
  end
end
