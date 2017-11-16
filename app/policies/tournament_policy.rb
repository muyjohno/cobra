class TournamentPolicy < ApplicationPolicy
  def show?
    !record.private? || record.user == user
  end

  def create?
    user
  end

  def update?
    user && record.user == user
  end

  def destroy?
    update?
  end

  def upload_to_abr?
    update?
  end

  def save_json?
    show?
  end

  def cut?
    update?
  end
end
