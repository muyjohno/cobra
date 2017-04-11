class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :start]

  def index
    @tournaments = Tournament.all
  end

  def show
  end

  def new
    @new_tournament = Tournament.new
  end

  def create
    @new_tournament = Tournament.new(tournament_params)

    if @new_tournament.save
      redirect_to tournament_path(@new_tournament)
    else
      render :new
    end
  end

  def start
    @tournament.start!

    redirect_to tournament_path(@tournament)
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def tournament_params
    params.require(:tournament).permit(:name)
  end
end
