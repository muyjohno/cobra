class Tournament < ApplicationRecord
  has_many :players
  enum status: [:registering]
end
