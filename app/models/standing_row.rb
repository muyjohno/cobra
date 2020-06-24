class StandingRow < ApplicationRecord
  belongs_to :stage
  belongs_to :player

  delegate :name, :corp_identity, :runner_identity, :manual_seed, to: :player

  def corp_identity
    identity(player.corp_identity)
  end

  def runner_identity
    identity(player.runner_identity)
  end

  private

  def identity(id)
    Identity.find_or_initialize_by(name: id)
  end
end
