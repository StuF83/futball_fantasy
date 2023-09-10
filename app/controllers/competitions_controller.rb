class CompetitionsController < ApplicationController
  def show
    user = current_user
    @competitions = user.competitions
  end
end
