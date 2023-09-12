class CompetitionsController < ApplicationController
  def index
    user = current_user
    @competitions = user.competitions
  end

  def show
    @competition = Competition.find(params[:id])
    @game_weeks = @competition.game_weeks
    @users = User.all
  end
end
