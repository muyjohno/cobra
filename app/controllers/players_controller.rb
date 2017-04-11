class PlayersController < ApplicationController
  before_action :set_tournament

  def index
  end

  def create
    player = @tournament.players.new(player_params)

    player.save
    redirect_to tournament_players_path(@tournament)
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def player_params
    params.require(:player).permit(:name)
  end
end
