class GameWeeksController < ApplicationController

  def update
    @competition = Competition.find(params[:id])
    @game_week = GameWeek.find(@competition.match_day)
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

      if match.status == "FINISHED"
        predictions = match.match_predictions
        predictions.each do |p|
          if (p.home_score_guess? || p.away_score_guess?) && p.result == "pending"
            p.update_result

            user_competition = UserCompetition.where(user_id: p.user_id, competition_id: params[:competition_id]).first
            user_competition.score += p.result.to_i
          end
        end
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
