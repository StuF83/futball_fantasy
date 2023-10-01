class GameWeeksController < ApplicationController
  def index
    @game_weeks = GameWeek.all
  end

  def show
    @game_week = GameWeek.find(params[:id])
  end

  def new
    @competition = Competition.find(params[:competition_id])
    @game_week = GameWeek.new
  end

  def create
    @competition = Competition.find(params[:competition_id])
    @game_week = GameWeek.new(game_week_params)
    if @game_week.save
      season = '2023'
      football_data_api = Rails.application.credentials.football_data_api
      api_data = URI.open("https://api.football-data.org/v4/competitions/PL/matches?season=#{season}&dateFrom=#{game_week_params[:start_date]}&dateTo=#{game_week_params[:end_date]}",
        "X-Auth-Token" => football_data_api
      ).read

      data = JSON.parse(api_data)
      data['matches'].each do |match|
        @match = Match.new(home_team: match["homeTeam"]["tla"], away_team: match["awayTeam"]["tla"], home_score: match["score"]["fullTime"]["home"], away_score: match["score"]["fullTime"]["away"], scheduled_date: match["utcDate"], status: match["score"]["winner"]  )
        @match.save

        @competition.users.each do |user|
          match_prediction = @match.match_predictions.build
          match_prediction.user = user
          match_prediction.cut_off_date = match_prediction.match.scheduled_date - 1
          match_prediction.save
        end
        @game_week.matches << @match
      end

      @competition.game_weeks << @game_week
      @competition.save
      redirect_to competition_game_weeks_path(@game_week) and return
    else
      render :new, status: 422
    end
  end

  def edit

  end

  def update

  end

  def destroy
    game_week = GameWeek.find(params[:id])
    game_week.destroy
    redirect_to game_weeks_path, status: :see_other
  end

  private

  def game_week_params
    params.require(:game_week).permit(:start_date, :end_date, :week_number, matches_attributes: [:match_predictions_attributes => {}])
  end

  def build_player_match_predictions
    @players = User.all
    @game_week.matches.each do |match|
      @players.each do |player|
        match_prediction = match.match_predictions.build
        match_prediction.user = player
        match_prediction.save
      end
    end
  end
end
