class GameWeeksController < ApplicationController
  def index
    @game_weeks = GameWeek.all
  end

  def show
    @game_week = GameWeek.find(params[:id])
  end

  def new
    @game_week = GameWeek.new
  end

  def create
    @game_week = GameWeek.new(game_week_params)
    if @game_week.save
      # existing_matches = check_for_existing_games
      # existing_matches.each do |match|
      #   @game_week.matches << match
      # end
      season = '2023'
      football_data_api = Rails.application.credentials.football_data_api
      api_data = URI.open("https://api.football-data.org/v4/competitions/PL/matches?season=#{season}&dateFrom=#{game_week_params[:start_date]}&dateTo=#{game_week_params[:end_date]}",
        "X-Auth-Token" => football_data_api
      ).read

      data = JSON.parse(api_data)
      data['matches'].each do |match|
        @match = Match.new(home_team: match["homeTeam"]["tla"], away_team: match["awayTeam"]["tla"], home_score: match["score"]["fullTime"]["home"], away_score: match["score"]["fullTime"]["away"], scheduled_date: match["utcDate"]  )
        # if the match scheduled date and home_team matches a record, run a match.update else match.save
        @match.save
        @game_week.matches << @match
      end
      redirect_to game_week_path(@game_week) and return
    else
      render :new, status: 422
    end
  end

  def destroy
    game_week = GameWeek.find(params[:id])
    game_week.destroy
    redirect_to game_weeks_path, status: :see_other
  end

  private

  def game_week_params
    params.require(:game_week).permit(:start_date, :end_date, :week_number )
  end

  def check_for_existing_games
    # Match.where(scheduled_date: game_week_params[:start_date]..game_week_params[:end_date])
    # we need to check the database before we call the api to check if the games already exist in the database
    # db quiery to find any matches between the dates required - will return an array of match hashes
  end
end
