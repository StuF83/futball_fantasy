module ApiServices
  class FootballDataApi
    def initialize(params)
      @league = params[:league]
      @season = params[:season]
    end

    def call_api
      football_data_api_key = Rails.application.credentials.football_data_api
      base_url = "https://api.football-data.org/v4"
      URI.open("#{base_url}/competitions/#{@league}/matches?season=#{@season}",
        "X-Auth-Token" => football_data_api_key
      ).read
    end
  end
end
