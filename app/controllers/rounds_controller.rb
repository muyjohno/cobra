class RoundsController < ApplicationController
  def create
    tournament = Tournament.find(params[:tournament_id])
    tournament.pair_new_round!

    redirect_to tournament_path(tournament)
  end
end
