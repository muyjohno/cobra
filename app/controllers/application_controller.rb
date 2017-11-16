class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorised
  rescue_from ActiveRecord::RecordNotFound, with: :error

  helper_method :current_user, :user_signed_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    !!current_user
  end

  protected

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  private

  def user_not_authorised
    flash[:alert] = "🔒 Sorry, you can't do that"
    redirect_to(request.referrer || root_path)
  end

  def error
    redirect_to error_path
  end
end
