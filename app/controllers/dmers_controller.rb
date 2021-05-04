class DmersController < ApplicationController

  def index 
    @dmers = Dmer.all
  end 

  def import 
    Dmer.import(params[:file])
    redirect_to dmers_path
  end 

end
