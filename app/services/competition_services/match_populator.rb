module CompetitionServices
  class MatchPopulator
    
    def initialize(competition, season_data)
      @competition = competition
      @season_data = season_data
    end
    
    def populate_game_week_matches
      @competition.game_weeks.each do |game_week|
        @season_data["matches"].each do |match_data|
          if match_data["matchday"] == game_week.week_number
            match = game_week.matches.build(
              home_team: match_data["homeTeam"]["tla"],
              away_team: match_data["awayTeam"]["tla"],
              home_score: match_data["score"]["fullTime"]["home"],
              away_score: match_data["score"]["fullTime"]["away"],
              scheduled_date: match_data["utcDate"],
              status: match_data["status"],
              match_day: match_data["matchday"],
              api_id: match_data["id"]
            )
            p "Building match: #{match.attributes}"
          end
        end
        game_week.save
      end
    end

  end
end

