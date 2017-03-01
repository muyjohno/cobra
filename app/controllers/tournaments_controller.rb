class TournamentsController < ApplicationController
  before_filter :set_tournament, :show

  def show
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end
end
