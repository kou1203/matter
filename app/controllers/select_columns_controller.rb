class SelectColumnsController < ApplicationController

  def new 
    @category = params[:category]
    @select_column = SelectColumn.new 
    session[:previous_url] = request.referer
  end 

  def create 
    @select_column = SelectColumn.new(select_column_params)
    @select_column.save 
    if @select_column.save 
      redirect_to session[:previous_url]
    else 
      render :new 
    end 
  end 

  private 
  def select_column_params
    params.require(:select_column).permit(:category, :name)
  end
end
