class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_devise_parameters, if: :devise_controller?
  before_action :authenticate_user!

  private

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])  
  end
end
