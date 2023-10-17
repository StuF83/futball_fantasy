class MatchPredictionsController < ApplicationController
  def index
    @user = current_user
    @game_week = GameWeek.find(params[:game_week_id])
    @match_predictions = GameWeek.find(params[:game_week_id]).match_predictions.where(user: current_user)
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
    raise
    @predictions = []
    params["predictions"].each do |prediction|
      # @match_prediction = MatchPrediction.new(home_score_guess: prediction["home_score_guess"],
      #                     away_score_guess: prediction["away_score_guess"],
      #                     user_id: current_user.id,
      #                     match_id: prediction["match_id"])
      @match_prediction = MatchPrediction.new(home_score_guess: match_prediction_params["home_score_guess"],
                            away_score_guess: match_prediction_params["away_score_guess"],
                            user_id: current_user.id,
                            match_id: match_prediction_params["match_id"])

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
    bot.ready do |event|
      bot.send_message("1135660158635233323", message)
      bot.stop
    end
    bot.run
  end

  def current_predictions
    @current_predictions = MatchPrediction.includes(:match).where(user: current_user, cut_off_date: (Date.today + 1.day)..(Date.today + 7.day) )
    @user = current_user
  end

  def current_predictions_update
    @user = current_user
    @user.update(match_prediction_params)
  end

  # not for production
  def generate_predictions
    @predictions = MatchPrediction.all.where(result: "pending", cut_off_date: ( Time.now.midnight - 90.day)..Time.now.midnight)
    @predictions.each do |prediction|
      prediction.home_score_guess = rand(0..4)
      prediction.away_score_guess = rand(0..4)
      prediction.update_result
    end
  end

  private

  def match_prediction_params
    params.require(:user).permit(match_predictions_attributes: [:home_score_guess, :away_score_guess, :id])
  end
end
