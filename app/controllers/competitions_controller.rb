class CompetitionsController < ApplicationController
  def index
    user = current_user
    @competitions = user.competitions
  end

  def show
    @competition = Competition.find(params[:id])
    # @users = []
    # @competition.users.each {|user| @users << user.email}
    # @users.sort!
    @users = @competition.users

    # we want our row to be a join of the match row, with the match prediction row. Then we want to select only the rows that belong to the competition. And we want to group them by game_week.

    # @match_and_predictions = Match.joins("SELECT home_team, away_team, home_score, away_score, home_score_guess, away_score_guess, user_id FROM matches JOIN match_predictions ON matches.id = match_predictions.match_id;")

    @match_and_predictions = Match.joins(:match_predictions)




  end
end
