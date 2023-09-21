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
    @users = @competition.users
    @competition_game_weeks = GameWeek.joins(:matches => [:match_predictions => [:user => :competitions]]).where(:competitions => {:id => params[:id]}).distinct
    @competition_game_weeks.each do |game_week|
      game_week.match_predictions.each do |match_prediction|
        match_prediction.update_result
      end
    end
  end

  def edit
    @competition = Competition.find(params[:id])
    @users = User.all
  end

  def update
    @competition = Competition.find(params[:id])
    @updated_users = []
    competition_user_params[:user_ids].each do |id|
      user = User.find(id)
      @competition.users << user
      @competition.save
    end
    redirect_to competition_path(@competition)
  end

  private

  def competition_params
    params.require(:competition).permit(:name, users_attributes: {})
  end

  def competition_user_params
    params.require(:competition).permit({user_ids: []})

  end
end
