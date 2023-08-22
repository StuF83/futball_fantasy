class MatchPredictionsController < ApplicationController
  def index
    @user = current_user
    # Here I am trying to map the form in the match_prediction/index to the matches
    # I need a week and some matches, so I am just setting @week = GameWeek.last
    @week = GameWeek.last
    @matches = @week.matches

    # Below, @empty_guesses is an empty array. We iterate over @matches, and for each match we are
    # creating an empty MatchPrediction and storing it in the empty array. This is like having
    # @match_prediction = MatchPrediction.new if the form was linked to one instance of the class.
    @empty_guesses = []
    @matches.each do |match|
      @empty_guesses.push(MatchPrediction.new)
    end
  end

  def create

    answer1 = {home_score_guess: params["home_score_guess_0"], away_score_guess: params['away_score_guess_0'], user_id: params[:user_id] }
    answer2 = {home_score_guess: params["home_score_guess_1"], away_score_guess: params['away_score_guess_1'], user_id: params[:user_id] }
    @match_prediction = MatchPrediction.new(answer1)
    # @match_prediction2 = MatchPrediction.new(answer2)
    if @match_prediction.save
      send_guesses(@match_prediction)
      redirect_to match_predictions_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def send_guesses(guess)
    bot = Discordrb::Bot.new token: 'MTEzNTg4MjYxMTA0MzA3ODI1OA.GDRsNT.Ewjcmww20_OJTnUYRuSsfIAxz8xK5Z-6VV4xJc'
    bot.send_message("1135660158635233323", "Here are #{guess.user.email}'s guesses! Arsenal - Chelsea #{guess.home_score_guess} - #{guess.away_score_guess}")
    bot.run
  end

  private

  def match_prediction_params
    params.require(:match_prediction).permit(:home_score_guess, :away_score_guess, :user_id)
  end
end
