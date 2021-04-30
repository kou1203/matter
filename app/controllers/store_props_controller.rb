class StorePropsController < ApplicationController

  def index 
    @store_props = StoreProp.all
  end 

  def import 
    StoreProp.import(params[:file])
    redirect_to root_path
  end 

  def show 
    @store_prop = StoreProp.find(params[:id])
  end
end
