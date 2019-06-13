# home controller
class HomeController < ApplicationController

  def index
    @lookups = Lookup.all
    render json: @lookups
  end
end
