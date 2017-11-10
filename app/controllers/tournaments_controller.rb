class TournamentsController < ApplicationController
  before_action :set_tournament, except: [:index, :create, :shortlink]

  def index
    authorize Tournament

    @tournaments = Tournament.order(created_at: :desc)
  end

  def show
    authorize @tournament

    redirect_to tournament_rounds_path(@tournament)
  end

  def create
    authorize Tournament

    @new_tournament = current_user.tournaments.new(tournament_params)

    if @new_tournament.save
      redirect_to tournament_players_path(@new_tournament)
    else
      render :new
    end
  end

  def edit
    authorize @tournament
  end

  def update
    authorize @tournament

    @tournament.update(tournament_params)

    redirect_to edit_tournament_path(@tournament)
  end

  def destroy
    authorize @tournament

    @tournament.destroy!

    redirect_to tournaments_path
  end

  def upload_to_abr
    authorize @tournament

    response = AbrUpload.upload!(@tournament)

    if(response[:code])
      @tournament.update(abr_code: response[:code])
    end

    redirect_to edit_tournament_path(@tournament)
  end

  def save_json
    authorize @tournament

    data = NrtmJson.new(@tournament).data

    send_data data.to_json,
      type: :json,
      disposition: :attachment,
      filename: "#{@tournament.name.underscore}.json"
  end

  def cut
    authorize @tournament

    number = params[:number].to_i
    redirect_to standings_tournament_players_path(@tournament) unless [4,8].include? number

    next_tournament = @tournament.cut_to!(:double_elim, number)

    redirect_to tournament_players_path(next_tournament)
  end

  def shortlink
    tournament = Tournament.find_by!(slug: params[:slug].upcase)

    authorize tournament, :show?

    redirect_to tournament_path(tournament)
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def tournament_params
    params.require(:tournament).permit(:name, :pairing_sort)
  end
end
