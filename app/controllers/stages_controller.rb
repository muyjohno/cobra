class StagesController < ApplicationController
  before_action :set_tournament

  def create
    authorize @tournament, :update?

    stage = @tournament.stages.create(format: :swiss)
    @tournament.players.each { |p| stage.players << p }

    redirect_to tournament_rounds_path(@tournament)
  end

  def destroy
    authorize @tournament, :update?

    Stage.find(params[:id]).destroy!

    redirect_to tournament_rounds_path(@tournament)
  end
end
