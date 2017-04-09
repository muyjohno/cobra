class Tournament < ApplicationRecord
  has_many :players
  enum status: [:registering, :waiting]

  alias_method :start!, :waiting!
end
