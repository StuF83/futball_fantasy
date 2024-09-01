class CompetitionsController < ApplicationController

  def index
    user = current_user
    current_user.role == "admin" ? @competitions = Competition.all : @competitions = user.competitions
  end

  def new
    @competition = Competition.new
    authorize @competition, :create?
  end

  def create
    @competition = Competition.new(competition_params)
    authorize @competition, :create?
    league = 'PL'
    season = '2024'
    api_data = ApiServices::FootballDataApi.new(league: league, season: season).call_api

    season_data = JSON.parse(api_data)
    CompetitionServices::GameWeekCreator.new(@competition, season_data).create_game_weeks
    CompetitionServices::MatchPopulator.new(@competition, season_data).populate_game_week_matches
    # @competition.update_match_day
    redirect_to competition_path(@competition)
  end

  def show
    @competition = Competition.find(params[:id])
    @game_weeks = GameWeek.includes( :competitions => [:users], :matches => [:match_predictions] ).where(:competitions => {:id => params[:id]}).order(:id)
  end


  def edit
    @competition = Competition.find(params[:id])
    @users = User.where(approved: true)
  end

  def update
    @competition = Competition.find(params[:id])
    competition_user_params[:user_ids].each do |id|
      @user = User.find(id)
      @competition.users << @user
      @competition.game_weeks.each do |game_week|
        game_week.matches.each do |match|
          match_prediction = match.match_predictions.build
          match_prediction.user = @user
          match_prediction.cut_off_date = match.scheduled_date - 1
          match_prediction.competition_id = @competition.id
          match_prediction.save
        end
      end
    end
    @competition.save
    redirect_to competition_path(@competition)
  end

  def leaderboard
    @competition = Competition.find(params[:id])
    @players = User.joins(:competitions)
    @scores = {}
    @game_weeks = GameWeek.includes( :competitions => [:users], :matches => [:match_predictions] ).where(:competitions => {:id => params[:id]}).order(:week_number)
    # raise
  end

  def current_match_day
    @competition = Competition.find(params[:id])
    @competition.update_match_day
  end

  private

  def competition_params
    params.require(:competition).permit(:name, users_attributes: {})
  end

  def competition_user_params
    params.require(:competition).permit({user_ids: []})

  end
end
