class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]

  def index
    @tournaments = Tournament.all
  end

  def show
  end

  def create
    @new_tournament = Tournament.new(tournament_params)

    if @new_tournament.save
      redirect_to tournament_players_path(@new_tournament)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @tournament.update(tournament_params)

    redirect_to edit_tournament_path(@tournament)
  end

  def destroy
    @tournament.destroy!

    redirect_to tournaments_path
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def tournament_params
    params.require(:tournament).permit(:name)
  end
end
