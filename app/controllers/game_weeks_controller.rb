class GameWeeksController < ApplicationController

  def show
    @competition = Competition.find(params[:competition_id])
    # @game_week = GameWeek.find(params[:id])
    @game_week = GameWeek.includes( :competitions => [:users], :matches => [:match_predictions] ).where(:competitions => {:id => params[:competition_id]}).where(:game_weeks => {:week_number => params[:id]})
    # raise
  end

  def update
    @competition = Competition.find(params[:competition_id])
    @game_week = GameWeek.find(params[:id])
    season = '2024'
    matchday = @game_week.week_number
    football_data_api = Rails.application.credentials.football_data_api
    api_data = URI.open("https://api.football-data.org/v4/competitions/PL/matches?season=#{season}&matchday=#{matchday}",
      "X-Auth-Token" => football_data_api
    ).read

    data = JSON.parse(api_data)
    data['matches'].each do |match_updated|
      match = Match.where(api_id: match_updated["id"]).first
      match.home_score = match_updated["score"]["fullTime"]["home"]
      match.away_score = match_updated["score"]["fullTime"]["away"]
      match.status = match_updated["status"]
      match.scheduled_date = match_updated["utcDate"]
      match.save
      
      predictions = match.match_predictions
      predictions.each do |p|
        p.update_result
      end
    end
    redirect_to competition_path(@competition)
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

end
