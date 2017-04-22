module Pairable
  extend ActiveSupport::Concern

  def unpairable_opponents
    opponents.map { |p| p.id ? p : Swissper::Bye }
  end
end
