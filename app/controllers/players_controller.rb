class PlayersController < ApplicationController
  before_action :set_tournament
  before_action :set_player, only: [:update, :destroy, :drop, :reinstate]

  def index
    authorize @tournament, :update?

    @players = @tournament.players.active.sort_by(&:name)
    @dropped = @tournament.players.dropped.sort_by(&:name)
  end

  def create
    authorize @tournament, :update?

    player = @tournament.players.create(player_params)
    @tournament.current_stage.players << player

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
    authorize @tournament, :show?
  end

  private

  def player_params
    params.require(:player)
      .permit(:name, :corp_identity, :runner_identity, :first_round_bye)
  end

  def set_player
    @player = Player.find(params[:id])
  end
end
