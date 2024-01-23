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
    @game_week = GameWeek.new
    @game_week.save
    # @competition = Competition.find(params[:competition_id])
    # @game_week = GameWeek.new(game_week_params)
    # if @game_week.save
      # season = '2023'
      # football_data_api = Rails.application.credentials.football_data_api
      # api_data = URI.open("https://api.football-data.org/v4/competitions/PL/matches?season=#{season}&dateFrom=#{game_week_params[:start_date]}&dateTo=#{game_week_params[:end_date]}",
      #   "X-Auth-Token" => football_data_api
      # ).read

      # data = JSON.parse(api_data)
      # data['matches'].each do |match|
      #   @match = Match.new(home_team: match["homeTeam"]["tla"], away_team: match["awayTeam"]["tla"], home_score: match["score"]["fullTime"]["home"], away_score: match["score"]["fullTime"]["away"], scheduled_date: match["utcDate"], status: match["score"]["winner"]  )
      #   @match.save

      #   @competition.users.each do |user|
      #     match_prediction = @match.match_predictions.build
      #     match_prediction.user = user
      #     match_prediction.cut_off_date = match_prediction.match.scheduled_date - 1
      #     match_prediction.save
      #   end
      #   @game_week.matches << @match
      # end

    #   @competition.game_weeks << @game_week
    #   @competition.save
    #   redirect_to competition_game_weeks_path(@game_week) and return
    # else
    #   render :new, status: 422
    # end
  end

  def edit

  end

  def update
    @competition = Competition.find(params[:id])
    @game_week = GameWeek.find(@competition.match_day)
    season = '2023'
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
      match.status = match_updated["score"]["winner"]
      match.save

      predictions = match.match_predictions
      predictions.each do |p|
      if (p.home_score_guess? || p.away_score_guess?) && p.result == "pending"
        p.update_result

        user_competition = UserCompetition.where(user_id: p.user_id, competition_id: params[:competition_id]).first
        user_competition.score += p.result.to_i
      end



    end

    end
    redirect_to game_week_path(@game_week)
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
