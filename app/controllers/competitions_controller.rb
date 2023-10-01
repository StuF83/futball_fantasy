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
    @users = @competition.users.order(:id)
    # a row is : match = [home_team, away_team, home_score, away_score] << user.match_prediction.home_guess and away guess

    @competition_game_weeks = GameWeek.includes( :competitions => [:users], :matches => [:match_predictions] ).where(:competitions => {:id => params[:id]})
    @competition_game_weeks.each do |game_week|
      game_week.match_predictions.each do |match_prediction|
        if match_prediction.home_score_guess? || match_prediction.away_score_guess?
          match_prediction.update_result
        end
      end
    end
    # raise
  end

  def edit
    @competition = Competition.find(params[:id])
    @users = User.all
  end

  def update
    @competition = Competition.find(params[:id])
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
