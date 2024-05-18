class CompetitionCreatorService

  def initialize(params)
    @name = params[:name]
    @league = params[:league]
    @season = params[:season]
  end

  def create_competition_and_populate_matches
    competition = Competition.new(name: @name, league: @league, season: @season)

    db_matches = Match.where(league_code: "PL").pluck(:api_id)

    football_data_api = Rails.application.credentials.football_data_api
    api_data = URI.open("https://api.football-data.org/v4/competitions/#{@league}/matches?season=#{@season}",
      "X-Auth-Token" => football_data_api
    ).read

    season_data = JSON.parse(api_data)
    season_data["matches"].each do |match|
      if db_matches.include?(match["id"])
        db_match = Match.where(api_id: match["id"]).first
        competition.matches << db_match
      else
        @match = Match.new(
          home_team: match["homeTeam"]["tla"],
          away_team: match["awayTeam"]["tla"],
          home_score: match["score"]["fullTime"]["home"],
          away_score: match["score"]["fullTime"]["away"],
          scheduled_date: match["utcDate"],
          status: match["score"]["winner"],
          match_day: match["matchday"],
          api_id: match["id"],
          league_code: match["competition"]["code"])
          @match.save
          competition.matches << match
        end
      end

    competition.save
    return competition

  end
end
