class DmerSenbaisController < ApplicationController
  before_action :authenticate_user!
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @q = DmerSenbai.includes(:user).ransack(params[:q])
    @dmer_senbais = 
      if params[:q].nil?
        DmerSenbai.none 
      else
        @q.result(distinct: false)
      end
    @dmer_senbais_data = @dmer_senbais.page(params[:page]).per(100)
  end 

  def show
    @dmer_senbai = DmerSenbai.find(params[:id])
  end

  def new 
  end 

  def create 
  end 

  def edit 
  end 

  def update 
  end 

  def import 
    if params[:file].present?
      if DmerSenbai.csv_check(params[:file]).present?
        redirect_to dmer_senbais_path , alert: "エラーが発生したため中断しました#{DmerSenbai.csv_check(params[:file])}"
      else
        message = DmerSenbai.import(params[:file]) 
        redirect_to dmer_senbais_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to dmer_senbais_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  private
end
