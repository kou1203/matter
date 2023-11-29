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
      redirect_to session[:previous_url],alert: "#{@select_column.category}に#{@select_column.name}を追加しました。"
    else 
      render :new 
    end 
  end 

  def edit 
    @select_column = SelectColumn.find(params[:id])
    session[:previous_url] = request.referer
  end 
  
  def update 
    @select_column = SelectColumn.find(params[:id])
    @select_column.update(select_column_params)
    redirect_to session[:previous_url],alert: "#{@select_column.category}の名前を修正しました。"
    
  end 
  
  def destroy 
    @select_column = SelectColumn.find(params[:id])
    @select_column.destroy
    redirect_to request.referer,alert: "#{@select_column.category}の#{@select_column.name}を削除しました。"
  end 

  private 
  def select_column_params
    params.require(:select_column).permit(:category, :name)
  end
end
