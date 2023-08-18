class MatchPredictionsController < ApplicationController
  def index
    @user = current_user
    @match_prediction = MatchPrediction.new
  end

  def create

    answer1 = {home_score_guess: params["home_score_guess_0"], away_score_guess: params['away_score_guess_0'], user_id: params[:user_id] }
    answer2 = {home_score_guess: params["home_score_guess_1"], away_score_guess: params['away_score_guess_1'], user_id: params[:user_id] }
    @match_prediction1 = MatchPrediction.new(answer1)
    @match_prediction2 = MatchPrediction.new(answer2)
    send_guesses(@match_prediction1)
    # if @match_prediction.save
    #   redirect_to match_predictions_path
    # else
    #   render :new, status: :unprocessable_entity
    # end
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
