class RoundsController < ApplicationController
  before_action :set_tournament
  before_action :set_round, only: [:show, :destroy]

  def index
  end

  def show
  end

  def create
    @tournament.pair_new_round!

    redirect_to tournament_rounds_path(@tournament)
  end

  def destroy
    @round.destroy!

    redirect_to tournament_rounds_path(@tournament)
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def set_round
    @round = Round.find(params[:id])
  end
end
