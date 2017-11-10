class RoundsController < ApplicationController
  before_action :set_tournament
  before_action :set_round, only: [:show, :destroy, :repair]

  def index
    authorize @tournament, :show?

    @current_round = @tournament.rounds.last
    @other_rounds = @tournament.rounds - [@current_round]
  end

  def show
    authorize @tournament, :show?
  end

  def create
    authorize @tournament, :update?

    @tournament.pair_new_round!

    redirect_to tournament_rounds_path(@tournament)
  end

  def destroy
    authorize @tournament, :update?

    @round.destroy!

    redirect_to tournament_rounds_path(@tournament)
  end

  def repair
    authorize @tournament, :update?

    @round.repair!

    redirect_to tournament_round_path(@tournament, @round)
  end

  private

  def set_round
    @round = Round.find(params[:id])
  end
end
