class PlayersController < ApplicationController
  before_action :set_tournament
  before_action :set_player, only: [:update, :destroy, :drop, :reinstate]

  def index
    @players = @tournament.players.active
    @dropped = @tournament.players.dropped
  end

  def create
    @tournament.players.create(player_params)

    redirect_to tournament_players_path(@tournament)
  end

  def update
    @player.update(player_params)

    redirect_to tournament_players_path(@tournament)
  end

  def destroy
    @player.destroy

    redirect_to tournament_players_path(@tournament)
  end

  def standings
    @standings = @tournament.standings
  end

  def drop
    @player.update(active: false)

    redirect_to tournament_players_path(@tournament)
  end

  def reinstate
    @player.update(active: true)

    redirect_to tournament_players_path(@tournament)
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def player_params
    params.require(:player).permit(:name, :corp_identity, :runner_identity)
  end

  def set_player
    @player = Player.find(params[:id])
  end
end
