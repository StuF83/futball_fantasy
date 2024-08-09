class CompetitionPolicy < ApplicationPolicy
  def create?
    user.admin?
  end
end
