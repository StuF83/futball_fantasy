class MatchPredictionsController < ApplicationController
  def index
    @user = current_user
    @game_week = GameWeek.find(params[:game_week_id])
    @match_predictions = GameWeek.find(params[:game_week_id]).match_predictions
  end

  def new
    @user = current_user
    @week = GameWeek.find(params[:game_week_id])
    @matches = @week.matches
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
    # send_guesses(@predictions)
  end

  def edit
    @match_prediction = MatchPrediction.find(params[:id])
  end

  def update
    @match_prediction = MatchPrediction.find(params[:id])
    if @match_prediction.update(match_prediction_params)
      #need to add a redirect here
      #also an updated bot message to discord
    else
      raise
      render :edit, status: :unprocessable_entity
    end
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
    bot.send_message("1135660158635233323", message)
    bot.run
    # here there is still an issue, becasue when the bot.run command uses websocket to open a channel
    # that channel stays open and the page gets stuck - NEED TO SORT THAT
    raise
    bot.kill
  end

  private

  def match_prediction_params
    params.require(:match_prediction).permit(:home_score_guess, :away_score_guess, :user_id, :match_id)
  end
end
