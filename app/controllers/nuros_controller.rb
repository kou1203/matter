class NurosController < ApplicationController
  before_action :set_month
  def index 
    @q = Nuro.ransack(params[:q])
    @nuros = 
      if params[:q].nil?
        Nuro.none 
      else
        @q.result(distinct: false)
      end
      @nuros_data = @nuros.page(params[:page]).per(100)
      session[:previous_url] = request.referer
  end 

  def show 
    @nuro = Nuro.find(params[:id])
  end 

  def years_result
    @nuros = Nuro.includes(:nuro_payments).where(date: @month.all_year)
  end 

  def monthly_result
    @nuros = Nuro.includes(:nuro_payments).where(date: @month.all_month).where.not(status: "キャンセル").where(current_month_cancel: nil)
  end 

  def import
    if params[:file].present?
      # if Airpay.csv_check(params[:file]).present?
      #   redirect_to airpays_path , alert: "エラーが発生したため中断しました#{Airpay.csv_check(params[:file])}"
      # else
      message = Nuro.import(params[:file]) 
      redirect_to nuros_path, alert: "インポート処理を完了しました#{message}"
      # end
    else
      redirect_to nuros_path, alert: "インポートに失敗しました。ファイルの中身に問題ないか確認してください。"
    end
  end

  private 
  def set_month
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
  end 
end
