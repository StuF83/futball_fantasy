class Competition < ApplicationRecord
  has_many :user_competitions
  has_many :users, through: :user_competitions

  has_many :competition_game_weeks
  has_many :game_weeks, through: :competition_game_weeks

  def update_match_day
    season = '2023'
    football_data_api = Rails.application.credentials.football_data_api
    api_data = URI.open("https://api.football-data.org/v4/competitions/PL/standings?season=#{season}",
      "X-Auth-Token" => football_data_api
    ).read

    season_data = JSON.parse(api_data)

    self.match_day = season_data["season"]["currentMatchday"]
    self.save
  end
end
