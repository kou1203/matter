class ReversalProductsController < ApplicationController

  def index 
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    @reversal_products = ReversalProduct.where(reversal_date: @month.all_month)

  end 

  def import 
    if params[:file].present?
      if ReversalProduct.csv_check(params[:file]).present?
        redirect_to reversal_products_path , alert: "エラーが発生したため中断しました#{ReversalProduct.csv_check(params[:file])}"
      else
        message = ReversalProduct.import(params[:file]) 
        redirect_to reversal_products_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to reversal_products_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 
  private 
  def reversal_product_params
    params.require(:reversal_product).permit(
      :controll_num,
      :product,
      :store_name,
      :user_id,
      :date,
      :result_date,
      :reversal_date,
      :price
    )
  end 
end
