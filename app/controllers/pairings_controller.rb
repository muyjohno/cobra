class PairingsController < ApplicationController
  def create
    round.pairings.create(pairing_params)

    redirect_to tournament_round_path(tournament, round)
  end

  def report
    pairing.update(score_params)

    redirect_to tournament_rounds_path(tournament)
  end

  def destroy
    pairing.destroy

    redirect_to tournament_round_path(tournament, round)
  end

  private

  def tournament
    @tournament ||= Tournament.find(params[:tournament_id])
  end

  def round
    @round ||= Round.find(params[:round_id])
  end

  def pairing
    @pairing ||= Pairing.find(params[:id])
  end

  def pairing_params
    params.require(:pairing).permit(:player1_id, :player2_id, :table_number)
  end

  def score_params
    params.require(:pairing).permit(:score1, :score2)
  end
end
