class PlayersController < ApplicationController
  before_action :set_tournament
  before_action :set_player, only: [:update, :destroy, :drop, :reinstate]

  def create
    authorize @tournament, :update?

    @tournament.players.create(player_params)

    redirect_to tournament_path(@tournament)
  end

  def update
    authorize @tournament, :update?

    @player.update(player_params)

    redirect_to tournament_path(@tournament)
  end

  def destroy
    authorize @tournament, :update?

    @player.destroy

    redirect_to tournament_path(@tournament)
  end

  def standings
    authorize @tournament, :show?

    @standings = @tournament.standings
    @up_to = @tournament.rounds.select(&:completed?).map(&:number).max
  end

  def drop
    authorize @tournament, :update?

    @player.update(active: false)

    redirect_to tournament_path(@tournament)
  end

  def reinstate
    authorize @tournament, :update?

    @player.update(active: true)

    redirect_to tournament_path(@tournament)
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
