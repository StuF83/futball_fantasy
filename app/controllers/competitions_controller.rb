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
    season = '2024'
    football_data_api = Rails.application.credentials.football_data_api
    api_data = URI.open("https://api.football-data.org/v4/competitions/PL/matches?season=#{season}",
      "X-Auth-Token" => football_data_api
    ).read

    season_data = JSON.parse(api_data)
    match_days = []
    season_data["matches"].each do |match|
      match_days << match["matchday"]
    end
    match_days.max.times do |i|
      @competition.game_weeks << GameWeek.create(week_number: i+1)
      @competition.save
    end
    season_data["matches"].each do |match|
      @match = Match.new(home_team: match["homeTeam"]["tla"], away_team: match["awayTeam"]["tla"], home_score: match["score"]["fullTime"]["home"], away_score: match["score"]["fullTime"]["away"], scheduled_date: match["utcDate"], status: match["status"], match_day: match["matchday"], api_id: match["id"])
      @match.save
      @competition.game_weeks.where(week_number: @match.match_day ).first.matches << @match
    end
    @competition.update_match_day
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
          match_prediction.save
        end
      end
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
    params.require(:competition).permit(:name, users_attributes: {})
  end

  def competition_user_params
    params.require(:competition).permit({user_ids: []})

  end
end
