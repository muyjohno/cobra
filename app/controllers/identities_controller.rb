class IdentitiesController < ApplicationController
  def index
    skip_authorization

    render json: {
      corp: Identity.where(side: :corp).map(&:name),
      runner: Identity.where(side: :runner).map(&:name)
    }
  end
end
