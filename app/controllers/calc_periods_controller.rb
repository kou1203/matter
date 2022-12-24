class CalcPeriodsController < ApplicationController
  require 'csv'
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @calc_periods = CalcPeriod.all
    @calc_periods_val = CalcPeriod.where(sales_category: "評価売")
    @calc_periods_prof = CalcPeriod.where(sales_category: "実売")
    @dmer_date_progresses = DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    @dmer_date_progresses_last_update =  @dmer_date_progresses.maximum(:create_date)
    @aupay_date_progresses = AupayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    @aupay_date_progresses_last_update = @aupay_date_progresses.maximum(:create_date)
    @paypay_date_progresses = PaypayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    @paypay_date_progresses_last_update = @paypay_date_progresses.maximum(:create_date)
    @rakuten_pay_date_progresses = RakutenPayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    @rakuten_pay_date_progresses_last_update = @rakuten_pay_date_progresses.maximum(:create_date)
    @airpay_date_progresses = AirpayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    @airpay_date_progresses_last_update = @airpay_date_progresses.maximum(:create_date)
    @demaekan_date_progresses = DemaekanDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    @demaekan_date_progresses_last_update = @demaekan_date_progresses.maximum(:create_date)
    
    @austicker_date_progresses = AustickerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    @austicker_date_progresses_last_update = @austicker_date_progresses.maximum(:create_date)
    
    @dmersticker_date_progresses = DmerstickerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    @dmersticker_date_progresses_last_update = @dmersticker_date_progresses.maximum(:create_date)
    @cash_date_progresses = CashDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    @cash_date_progresses_last_update = @cash_date_progresses.maximum(:create_date)
    
  end 

  def new 
    @calc_period = CalcPeriod.new 
  end 

  def create 
    @calc_period = CalcPeriod.new (calc_period_params)
    @calc_period[:this_month_per] = @calc_period.this_month_per.to_f / 100
    @calc_period[:prev_month_per] = @calc_period.prev_month_per.to_f / 100
    if @calc_period.save
      redirect_to calc_periods_path, alert: "成果期間を新しく追加しました。"
    else 
      render :new, alert: "入力されていない項目があります。入力をお願いします。"
    end 
  end 

  def edit 
    @calc_period = CalcPeriod.find(params[:id])
    @calc_period[:this_month_per] = (@calc_period.this_month_per * 100).to_i
    @calc_period[:prev_month_per] = (@calc_period.prev_month_per * 100).to_i
  end 

  def update 
    @calc_period = CalcPeriod.find(params[:id])
    @calc_period.update(calc_period_params)
    @calc_period.update(set_percent_params)
    redirect_to calc_periods_path, alert: "#{@calc_period.name}の内容を更新しました。"

  end 

  def cash_csv_export 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @cash_date_progress = CashDateProgress.where(date: @month)
    @cash_date_progress = @cash_date_progress.where(create_date: @cash_date_progress.maximum(:create_date))
    @dmer_date_progress = DmerDateProgress.where(date: @month)
    @dmer_date_progress = @dmer_date_progress.where(create_date: @dmer_date_progress.maximum(:create_date))
    bases = ["中部SS","関西SS","関東SS","九州SS","フェムト", "サミット", "退職"]
    head :no_content
    filename = "実売資料#{@month}"
    columns_ja = [
      "拠点", "Ave","現状実売", "終着実売", "dメル一次成果現状実売","dメル一次成果終着実売"
    ]
    columns = [
      "base","average","profit_current","profit_fin","dmer1_profit_current","dmer1_profit_fin"
    ]
    bom = "\uFEFF"
    csv = CSV.generate(bom) do |csv|
      csv << columns_ja
      bases.each do |base|
        dmer_progress = @dmer_date_progress.where(base: base)
        cash_date_progress = @cash_date_progress.where(base: base)
        result_attributes = {}
        result_attributes["base"] = base
        if (cash_date_progress.sum(:profit_fin) == 0) || (cash_date_progress.sum(:shift_schedule) == 0)
          result_attributes["average"] = 0
        else  
          result_attributes["average"] = 
            (
              cash_date_progress.sum(:profit_fin).to_f / cash_date_progress.sum(:shift_schedule)
            ).round()
        end 
        result_attributes["profit_current"] = cash_date_progress.sum(:profit_current)
        result_attributes["profit_fin"] = cash_date_progress.sum(:profit_fin)
        result_attributes["dmer1_profit_current"] = dmer_progress.sum(:profit_current)
        result_attributes["dmer1_profit_fin"] = dmer_progress.sum(:profit_fin1)
        csv << result_attributes.values_at(*columns)
      end
    end 
    create_csv(filename,csv)
  end 
  private 

  def create_csv(filename, csv1)
    #ファイル書き込み
    File.open("./#{filename}.csv", "w") do |file|
      file.write(csv1)
    end
    #send_fileを使ってCSVファイル作成後に自動でダウンロードされるようにする
    stat = File::stat("./#{filename}.csv")
    send_file("./#{filename}.csv", filename: "#{filename}.csv", length: stat.size)
  end

  def calc_period_params 
    params.require(:calc_period).permit(
      :name                                           ,
      :sales_category                                 ,
      # 獲得期間
      :start_date_month                               ,
      :start_date_day                                 ,
      :end_date_month                                 ,
      :end_date_day                                   ,
      # 審査完了期間
      :start_done_month                               ,
      :start_done_day                                 ,
      :end_done_month                                 ,
      :end_done_day                                   ,
      # 締め日
      :closing_date_month                             ,
      :closing_date_day                               ,
      # パーセント
      :this_month_per                                 ,
      :prev_month_per                                 ,
      # 終着単価
      :price                                          ,
      :bonus1_len                                     ,
      :bonus2_len                                     ,
      :bonus1_price                                   ,
      :bonus2_price                                   ,
    )
  end 

  def calc_period_edit_params 
    params.require(:calc_period).permit(
      :name                                           ,
      :sales_category                                 ,
      # 獲得期間
      :start_date_month                               ,
      :start_date_day                                 ,
      :end_date_month                                 ,
      :end_date_day                                   ,
      # 締め日
      :closing_date_month                             ,
      :closing_date_day                               ,
      :price                                          ,
    )
  end 


  # パーセントを / 100 してFloat値にする ex) 60 => 0.6, set_month_per_floatはmodelにて格納されている
  def set_percent_params
    calc_period_edit_params.merge(@calc_period.set_month_per_float)
  end 
end
