class MatchPredictionsController < ApplicationController
  def current_predictions
    @current_predictions = MatchPrediction.includes(:match).where(user: current_user, cut_off_date: (Date.today + 1.day)..(Date.today + 14.day) )
    @user = current_user
  end

  def current_predictions_update
    @user = current_user
    @user.update(match_prediction_params)
    @match_predictions = []
    match_prediction_params["match_predictions_attributes"].each_value do |value|
      @match_predictions.push(MatchPrediction.where(id: value["id"]).first)
    end
    send_guesses(@match_predictions)
    redirect_to competitions_path
  end

  # not for production
  if  Rails.env.development? || Rails.env.test?
    def generate_predictions
      @predictions = MatchPrediction.all.where(result: "pending", cut_off_date: ( Time.now.midnight - 120.day)..Time.now.midnight)
      @predictions.each do |prediction|
        prediction.home_score_guess = rand(0..4)
        prediction.away_score_guess = rand(0..4)
        prediction.update_result
     end
    end

  end

  private

  def match_prediction_params
    params.require(:user).permit(match_predictions_attributes: [:home_score_guess, :away_score_guess, :id])
  end

  def send_guesses(predictions)
    # here we are creating a message, then iterating over the prediction and appending them
    # to the string
    message = "Here are #{current_user.email}'s guesses!\n"
    predictions.each do |prediction|
      message += "#{prediction.match.home_team} VS #{prediction.match.away_team}" +
                  "  #{prediction.home_score_guess} - #{prediction.away_score_guess}\n"
    end

    # here we are creating a new bot, which I have already invited to the channel,
    # and using the send_message method on the bot, which takes two parameters: channelid and message
    bot = Discordrb::Bot.new token: Rails.application.credentials.discord_bot_token
    bot.ready do |event|
      bot.send_message("1135660158635233323", message)
      bot.stop
    end
    bot.run
  end
end
