class MatchPredictionsController < ApplicationController
  def index
    @user = current_user
    # Here I am trying to map the form in the match_prediction/index to the matches
    # I need a week and some matches, so I am just setting @week = GameWeek.last
    @week = GameWeek.last
    @matches = @week.matches

    # Below, @empty_predictions is an empty array. We iterate over @matches, and for each match we are
    # creating an empty MatchPrediction and storing it in the empty array. This is like having
    # @match_prediction = MatchPrediction.new if the form was linked to one instance of the class.
    @empty_predictions = []
    @matches.each do |match|
      @empty_predictions.push(MatchPrediction.new)
    end
  end

  def create
    @predictions = []
    params["predictions"].each do |prediction|
      @match_prediction = MatchPrediction.new(home_score_guess: prediction["home_score_guess"],
                          away_score_guess: prediction["away_score_guess"],
                          user_id: current_user.id,
                          match_id: prediction["match_id"])

      if @match_prediction.save
        @predictions << @match_prediction
      else
        render :new, status: :unprocessable_entity
      end
    end

    send_guesses(@predictions)
    redirect_to root_path
  end

  def send_guesses(predictions)
    message = "Here are #{current_user.email}'s guesses!\n"
    predictions.each do |prediction|
      message += "#{prediction.match.home_team} VS #{prediction.match.away_team}" +
                  "  #{prediction.home_score_guess} - #{prediction.away_score_guess}\n"
    end

    bot = Discordrb::Bot.new token: 'MTEzNTg4MjYxMTA0MzA3ODI1OA.GDRsNT.Ewjcmww20_OJTnUYRuSsfIAxz8xK5Z-6VV4xJc'
    bot.send_message("1135660158635233323", message)
    bot.run
    raise
    bot.kill
  end

  private

  def match_prediction_params
    params.require(:match_prediction).permit(:home_score_guess, :away_score_guess, :user_id, :match_id)
  end
end
