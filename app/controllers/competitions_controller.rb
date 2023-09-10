class CompetitionsController < ApplicationController
  def index
    user = current_user
    @competitions = user.competitions
  end

  def show
    @competition = Competition.find(params[:id])
  end
end
