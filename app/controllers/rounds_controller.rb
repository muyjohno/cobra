class RoundsController < ApplicationController
  before_action :set_tournament
  before_action :set_round, only: [:show, :destroy, :repair]

  def index
    @current_round = @tournament.rounds.last
    @other_rounds = @tournament.rounds - [@current_round]
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

  def repair
    @round.repair!

    redirect_to tournament_round_path(@tournament, @round)
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def set_round
    @round = Round.find(params[:id])
  end
end
