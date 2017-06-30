class PlayersController < ApplicationController
  before_action :set_tournament
  before_action :set_player, only: [:update, :destroy, :drop, :reinstate]

  def index
    authorize @tournament, :edit?

    @players = @tournament.players.active
    @dropped = @tournament.players.dropped
  end

  def create
    authorize @tournament, :update?

    @tournament.players.create(player_params)

    redirect_to tournament_players_path(@tournament)
  end

  def update
    authorize @tournament, :update?

    @player.update(player_params)

    redirect_to tournament_players_path(@tournament)
  end

  def destroy
    authorize @tournament, :update?

    @player.destroy

    redirect_to tournament_players_path(@tournament)
  end

  def standings
    authorize @tournament, :show?

    @standings = @tournament.standings
  end

  def drop
    authorize @tournament, :update?

    @player.update(active: false)

    redirect_to tournament_players_path(@tournament)
  end

  def reinstate
    authorize @tournament, :update?

    @player.update(active: true)

    redirect_to tournament_players_path(@tournament)
  end

  def meeting
    authorize @tournament, :edit?
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
