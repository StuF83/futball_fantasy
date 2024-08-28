module CompetitionCreationServices
  class GameWeekCreator
    def initialize(competition, season_data)
      @competition = competition
      @season_data = season_data
    end

    def create_game_weeks
      game_weeks = @season_data["matches"].map { |match| match["matchday"]}.uniq
      game_weeks.each { |game_week| @competition.game_week.create!(week_number: game_week)}
    end
  end
end
