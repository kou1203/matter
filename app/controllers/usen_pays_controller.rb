class UsenPaysController < ApplicationController

  def index 
    @q = UsenPay.includes(:user).ransack(params[:q])
    @usen_pays = 
      if params[:q].nil?
        UsenPay.none 
      else 
        @q.result(distinct: false)
      end
      @usen_pays_data = @usen_pays.page(params[:page]).per(100)
  end  

  def monthly_data
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @shifts = Shift.includes(:user).where(shift: "キャッシュレス新規").where(start_time: @month.all_month)
    @results = Result.includes(:user).where(shift: "キャッシュレス新規").where(date: @month.all_month)
    @usen_pays = UsenPay.includes(:user).where(date: @month.all_month)
    @usen_pays_result = UsenPay.includes(:user).where(result_point: @month.all_month)
    @bases = ["中部SS","関西SS","関東SS","九州SS","2次店"]
  end

  def years_data
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @usen_pays = UsenPay.where(date: @month.all_year)
    @usen_pays_result = UsenPay.where(result_point: @month.all_year)
  end 

  def import 
    if params[:file].present?
      if UsenPay.csv_check(params[:file]).present?
        redirect_to usen_pays_path , alert: "エラーが発生したため中断しました#{UsenPay.csv_check(params[:file])}"
      else
        message = UsenPay.import(params[:file]) 
        redirect_to usen_pays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to usen_pays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def destroy
    @usen_pay = UsenPay.find(params[:id])
    @usen_pay.destroy
    redirect_to usen_pays_path, alert: "#{@usen_pay.store_name}を削除しました。"
  end 

  private 
end
