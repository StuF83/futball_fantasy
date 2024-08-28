module CompetitionCreationServices
  class MatchCreationService
    def initialize(competition, season_data)
      @competition = competition
      @season_data = season_data
    end

    def create_game_week_matches
      season_data["matches"].each do |match_data|
        if game_week = @competition.game_week.where(week_number: match["matchday"]).first
          game_week.matches.build(
            home_team: match["homeTeam"]["tla"],
            away_team: match["awayTeam"]["tla"],
            home_score: match["score"]["fullTime"]["home"],
            away_score: match["score"]["fullTime"]["away"],
            scheduled_date: match["utcDate"],
            status: match["status"],
            match_day: match["matchday"],
            api_id: match["id"]
          )
        else
          p "Error: game_week not found for match day #{match_data["matchday"]}"
        end
      end
    end
  end
end
