class HomeController < ApplicationController
  def home
    authorize Tournament, :index?

    @tournaments = Tournament.where(date: Date.today, private: false)
  end
end
