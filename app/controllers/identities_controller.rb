class IdentitiesController < ApplicationController
  def index
    skip_authorization

    render json: Identity.where(side: params[:side]).map(&:name)
  end
end
