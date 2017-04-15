class RoundsController < ApplicationController
  before_action :set_tournament

  def index
  end

  def show
    @round = Round.find(params[:id])
  end

  def create
    @tournament.pair_new_round!

    redirect_to tournament_rounds_path(@tournament)
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end
end
