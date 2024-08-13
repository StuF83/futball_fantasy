class PlayerPolicy < ApplicationPolicy
  def update?
    user.admin?
  end
end