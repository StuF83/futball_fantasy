class CompetitionsController < ApplicationController
  def index
    user = current_user
    @competitions = user.competitions
  end

  def show
    @competition = Competition.find(params[:id])
    @users = @competition.users

    @competition_matches = Match.joins(:match_predictions => [:user => [:competitions => :game_weeks]]).where(:competitions => {:id => params[:id]})

    @competition_game_weeks = GameWeek.joins(:matches => [:match_predictions => [:user => :competitions]]).where(:competitions => {:id => params[:id]}).distinct
    raise
  end
end
