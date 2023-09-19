class CompetitionsController < ApplicationController
  def index
    user = current_user
    @competitions = user.competitions
  end

  def new
    @competition = Competition.new
  end

  def create
    @competition = Competition.new(competition_params)

    ## not for production
    @competition.users << current_user
    ##

    @competition.save
    redirect_to competition_path(@competition)
  end

  def show
    @competition = Competition.find(params[:id])
    @competition_game_weeks = GameWeek.joins(:matches => [:match_predictions => [:user => :competitions]]).where(:competitions => {:id => params[:id]}).distinct
  end

  def add_players
    @competition = Competition.find(params[:competition_id])
  end

  private

  def competition_params
    params.require(:competition).permit(:name)

  end
end
