class CompetitionsController < ApplicationController
  def index
    user = current_user
    @competitions = user.competitions
  end

  def show
    @competition = Competition.find(params[:id])
    @user_game_weeks = @competition.game_weeks
    @game_weeks = @competition.game_weeks
    @users = @competition.users

    # when getting all the predictions for the competition, check which one's have a result of pending.
    # if any of the resutls are pending, trigger a method to update those pending results.


  end
end
