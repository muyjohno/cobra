class PairingsController < ApplicationController
  before_action :set_tournament
  attr_reader :tournament

  def index
    authorize @tournament, :show?

    @pairings = round.pairings.inject([]) do |pairings, p|
      pairings << {
        table_number: p.table_number,
        player1_name: p.player1.name,
        player2_name: p.player2.name
      }
      pairings << {
        table_number: p.table_number,
        player1_name: p.player2.name,
        player2_name: p.player1.name
      }
    end.sort_by { |p| p[:player1_name] }
  end

  def create
    authorize @tournament, :update?

    round.pairings.create(pairing_params)

    redirect_to tournament_round_path(tournament, round)
  end

  def report
    authorize @tournament, :update?

    pairing.update(score_params)

    redirect_back(fallback_location: tournament_rounds_path(tournament))
  end

  def destroy
    authorize @tournament, :update?

    pairing.destroy

    redirect_to tournament_round_path(tournament, round)
  end

  def match_slips
    authorize @tournament, :edit?

    if params[:collate]
      @pairings = round.pairings
        .each_slice(round.pairings.count/4).to_a
        .transpose
        .flatten
    else
      @pairings = round.pairings
    end
  end

  private

  def round
    @round ||= Round.find(params[:round_id])
  end

  def pairing
    @pairing ||= Pairing.find(params[:id])
  end

  def pairing_params
    params.require(:pairing).permit(:player1_id, :player2_id, :table_number, :side)
  end

  def score_params
    params.require(:pairing).permit(:score1, :score2, :side)
  end
end
