class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit
  after_action :verify_authorized, unless: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised

  private

  def user_not_authorised
    flash[:alert] = 'You are not authorised to perform this action.'
    redirect_to(request.referrer || root_path)
  end
end
