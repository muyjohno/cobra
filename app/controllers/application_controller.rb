class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised

  helper_method :current_user, :user_signed_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    !!current_user
  end

  private

  def user_not_authorised
    flash[:alert] = 'You are not authorised to perform this action.'
    redirect_to(request.referrer || root_path)
  end
end
