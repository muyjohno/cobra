class NilPlayer
  def to_partial_path
    'players/player'
  end

  def name
    '(Bye)'
  end

  def pairings
    []
  end

  def id
    nil
  end

  def active?
    true
  end

  def points
    0
  end

  def corp_identity_object
    nil
  end

  def runner_identity_object
    nil
  end
end
