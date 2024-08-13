class PlayersController < ApplicationController
  def index
    @players_unapproved = User.where(approved: false)
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(admin_user_params)
      redirect_to players_path, notice: 'Player was successfully approved'
    else
      render :edit
    end
  end

  private

  def admin_user_params
    params.require(:user).permit(:approved)
  end
end
