class GameWeeksController < ApplicationController
  def index
    @game_weeks = GameWeek.all
  end

  def show
    @game_week = GameWeek.find(params[:id])
    # .includes(:matches)
  end

  def new
    @game_week = GameWeek.new
  end

  def create
    @game_week = GameWeek.new(game_week_params)
    if @game_week.save
      season = '2023'
      football_data_api = Rails.application.credentials.football_data_api
      api_data = URI.open("https://api.football-data.org/v4/competitions/PL/matches?season=#{season}&dateFrom=#{game_week_params[:start_date]}&dateTo=#{game_week_params[:end_date]}",
        "X-Auth-Token" => football_data_api
      ).read
      data = JSON.parse(api_data)
      data['matches'].each do |match|
        @match = Match.new(home_team: match["homeTeam"]["tla"], away_team: match["awayTeam"]["tla"], home_score: match["score"]["fullTime"]["home"], away_score: match["score"]["fullTime"]["away"], scheduled_date: match["utcDate"]  )
        @match.save
        @game_week.matches << @match
      end
      redirect_to game_week_path(@game_week) and return
    else
      render :new, status: 422
    end
  end

  def destroy
    # when the game week is destroyed, we don't want to delete the corresoponding matches. The matches need to have their foreign key id removed.
    # we need a join table between matches and game_weeks? A game week can have many matches, a match can belong to many game_weeks, or none...
  end

  private

  def game_week_params
    params.require(:game_week).permit(:start_date, :end_date, :week_number )
  end
end
