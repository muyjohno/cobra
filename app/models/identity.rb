class Identity < ApplicationRecord
  enum side: {
    corp: 1,
    runner: 2
  }

  def self.valid?(identity)
    Identity.exists?(name: identity)
  end
end
