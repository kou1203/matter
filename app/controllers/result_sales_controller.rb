class ResultSalesController < ApplicationController
  def index 
    @q = ResultSale.includes(:user).ransack(params[:q])
    @result_sales = 
    if params[:q].nil?
      ResultSale.none 
    else  
      @q.result(distinct: true)
    end
    @result_sales_data = @result_sales.page(params[:page]).per(100)
  end 

  def import 
    ResultSale.import(params[:file])
    message = ResultSale.import(params[:file]) 
    redirect_to result_sales_path, alert: "インポート処理を完了しました#{message}"
  end 

end
