class IdentitiesController < ApplicationController
  include IdentitiesHelper

  def index
    skip_authorization

    render json: {
      corp: Identity.where(side: :corp).map { |id| autocomplete_hash(id) },
      runner: Identity.where(side: :runner).map { |id| autocomplete_hash(id) }
    }
  end
end
