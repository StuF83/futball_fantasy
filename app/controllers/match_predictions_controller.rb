class MatchPredictionsController < ApplicationController
  def index
    @user = current_user
    @match_predictions = @user.match_predictions
    #get all users, get all match_predictions, get all points


    # @user = current_user
    # Here I am trying to map the form in the match_prediction/index to the matches
    # I need a week and some matches, so I am just setting @week = GameWeek.last
    # @week = GameWeek.last
    # @matches = @week.matches

    # Below, @empty_predictions is an empty array. We iterate over @matches, and for each match we are
    # creating an empty MatchPrediction and storing it in the empty array. This is like having
    # @match_prediction = MatchPrediction.new if the form was linked to one instance of the class.
    # @empty_predictions = []
    # @matches.each do |match|
    #   @empty_predictions.push(MatchPrediction.new)
    # end
  end

  def new

    @game_week = GameWeek.find(params[:game_week_id])
    match_count = @game_week.matches.count
    match_count.times { current_user.match_predictions.build }
    raise

    # @user = current_user
    # @game_week = GameWeek.find(params[:game_week_id])
    # @matches = @game_week.matches
    # @matches.each do |match|
    #   if match.match_predictions.exists?(user_id: current_user.id, match_id: match.id)
    #     match_prediction = match.match_predictions.where(user_id: current_user.id, match_id: match.id)
    #   else
    #     match_prediction = match.match_predictions.build
    #     match_prediction.user = current_user
    #     match_prediction.save
    #   end
    # end
  end

  def submit_game_week_predictions
    @game_week = GameWeek.find(params[:id])
    match_count = @game_week.matches.count
    match_count.times { current_user.match_predictions.build }
    # raise
    # @predictions = @game_week.match_predictions.where(user_id: current_user.id)

  end

  def create
    raise

    # based on the params sent through, we create an array to fill with newly created
    # instances of the MatchPrediction class.
    # @predictions = []
    # params["predictions"].each do |prediction|
    #   @match_prediction = MatchPrediction.new(home_score_guess: prediction["home_score_guess"],
    #                       away_score_guess: prediction["away_score_guess"],
    #                       user_id: current_user.id,
    #                       match_id: prediction["match_id"])

    #   if @match_prediction.save
    #     @predictions << @match_prediction
    #   else
    #     raise
    #     render :new, status: :unprocessable_entity
    #   end
    # end
    # after creating all instances, we send the array to the send_guesses method which will
    # deal with turning the guesses into a string, creating a bot and sending a message to the channel
    # send_guesses(@predictions)
  end

  def update
    raise
  end

  def show
    # @user = current_user
    # @game_week = GameWeek.find(params[:game_week_id])
    # p @user_match_predictions = MatchPrediction.where(user_id: @user.id)
    # @user_matches = Match.joins(:match_predictions).where(match_predictions: {user_id: @user.id})
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

  def destroy
    @user = current_user
    @user.match_predictions.destroy_all
    redirect_to user_match_predictions_path(@user)
  end

  private

  def match_prediction_params
    params.require(:match_prediction).permit(:home_score_guess, :away_score_guess, :user_id, :match_id)
  end
end
