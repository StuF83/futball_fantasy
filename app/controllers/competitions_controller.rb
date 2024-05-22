class CompetitionsController < ApplicationController
  def index
    user = current_user
    current_user.role == "admin" ? @competitions = Competition.all : @competitions = user.competitions
  end

  def new
    @competition = Competition.new
  end

  def create
    competition_creator_service = CompetitionCreatorService.new(competition_params)
    competition = competition_creator_service.create_competition_and_populate_matches
    redirect_to competition_path(competition)
  end

  def show
    @competition = Competition.find(params[:id])
    @game_weeks = GameWeek.includes( :competitions => [:users], :matches => [:match_predictions] ).where(:competitions => {:id => params[:id]}).order(:id)
  end

  # def edit
  #   @competition = Competition.find(params[:id])
  #   @users = User.all
  # end

  # def update
  #   @competition = Competition.find(params[:id])
  #   competition_user_params[:user_ids].each do |id|
  #     @user = User.find(id)
  #     @competition.users << @user
  #     @competition.game_weeks.each do |game_week|
  #       game_week.matches.each do |match|
  #         match_prediction = match.match_predictions.build
  #         match_prediction.user = @user
  #         match_prediction.cut_off_date = match.scheduled_date - 1
  #         match_prediction.save
  #       end
  #     end
  #   end
  #   @competition.save
  #   redirect_to competition_path(@competition)
  # end

  def add_users
    @competition = Competition.find(params[:id])
    @eligible_users = User.where.missing(:user_competitions).order(:email)
  end

  def update_users
    @competition = Competition.find(params[:id])
    competition_user_params[:user_ids].each do |id|
      @user = User.find(id)
      @competition.users << @user
    end
    @competition.save
    redirect_to competition_path(@competition)
  end

  def leaderboard
    @competition = Competition.find(params[:id])
    @players = @competition.users
    @competition_user_predictions = Competition.includes(users: :match_predictions).where(:competitions => {:id => params[:id]})
  end

  def current_match_day
    @competition = Competition.find(params[:id])
    @competition.update_match_day
  end

  private

  def competition_params
    # params.require(:competition).permit(:name, users_attributes: {})
    params.require(:competition).permit(:name, :league, :season)
  end

  def competition_user_params
    params.require(:competition).permit({user_ids: []})
  end
end
