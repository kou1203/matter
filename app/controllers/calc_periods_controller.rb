class CalcPeriodsController < ApplicationController
  require 'csv'
  include Base
  before_action :set_month
  def index 
    bases
    @calc_periods = CalcPeriod.all
    @calc_periods_val = CalcPeriod.where(sales_category: "評価売")
    @calc_periods_prof = CalcPeriod.where(sales_category: "実売")
    if DmerDateProgress.where(date: @month).exists?
      @dmer_date_progresses = DmerDateProgress.includes(:user).where(date: @month)
    else
      @dmer_date_progresses = DmerDateProgress.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @dmer_date_progresses_last_update =  @dmer_date_progresses.maximum(:create_date)
    @dmer_date_progresses = @dmer_date_progresses.where(create_date: @dmer_date_progresses_last_update)
    if DmerSenbaiDateProgress.where(date: @month).exists?
      @dmer_senbai_date_progresses = DmerSenbaiDateProgress.includes(:user).where(date: @month)
    else
      @dmer_senbai_date_progresses = DmerSenbaiDateProgress.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @dmer_senbai_date_progresses_last_update =  @dmer_senbai_date_progresses.maximum(:create_date)
    @dmer_senbai_date_progresses = @dmer_senbai_date_progresses.where(create_date: @dmer_senbai_date_progresses_last_update)

    if AupayDateProgress.where(date: @month).exists?
      @aupay_date_progresses = AupayDateProgress.includes(:user).where(date: @month)
    else  
      @aupay_date_progresses = AupayDateProgress.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @aupay_date_progresses_last_update = @aupay_date_progresses.maximum(:create_date)
    @aupay_date_progresses = @aupay_date_progresses.where(create_date: @aupay_date_progresses_last_update)

    if PaypayDateProgress.where(date: @month).exists?
      @paypay_date_progresses = PaypayDateProgress.includes(:user).where(date: @month)
    else  
      @paypay_date_progresses = PaypayDateProgress.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @paypay_date_progresses_last_update = @paypay_date_progresses.maximum(:create_date)
    @paypay_date_progresses = @paypay_date_progresses.where(create_date: @paypay_date_progresses_last_update)

    if RakutenPayDateProgress.where(date: @month).exists?
      @rakuten_pay_date_progresses = RakutenPayDateProgress.includes(:user).where(date: @month)
    else  
      @rakuten_pay_date_progresses = RakutenPayDateProgress.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @rakuten_pay_date_progresses_last_update = @rakuten_pay_date_progresses.maximum(:create_date)
    @rakuten_pay_date_progresses = @rakuten_pay_date_progresses.where(create_date: @rakuten_pay_date_progresses_last_update)

    if AirpayDateProgress.where(date: @month).exists?
      @airpay_date_progresses = AirpayDateProgress.includes(:user).where(date: @month)
    else  
      @airpay_date_progresses = AirpayDateProgress.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @airpay_date_progresses_last_update = @airpay_date_progresses.maximum(:create_date)
    @airpay_date_progresses = @airpay_date_progresses.where(create_date: @airpay_date_progresses_last_update)


    if DemaekanDateProgress.where(date: @month).exists?
      @demaekan_date_progresses = DemaekanDateProgress.includes(:user).where(date: @month)
    else  
      @demaekan_date_progresses = DemaekanDateProgress.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @demaekan_date_progresses_last_update = @demaekan_date_progresses.maximum(:create_date)
    @demaekan_date_progresses = @demaekan_date_progresses.where(create_date: @demaekan_date_progresses_last_update)

    if AustickerDateProgress.where(date: @month).exists?
      @austicker_date_progresses = AustickerDateProgress.includes(:user).where(date: @month)
    else  
      @austicker_date_progresses = AustickerDateProgress.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @austicker_date_progresses_last_update = @austicker_date_progresses.maximum(:create_date)
    @austicker_date_progresses = @austicker_date_progresses.where(create_date: @austicker_date_progresses_last_update)
    
    if DmerstickerDateProgress.where(date: @month).exists?
      @dmersticker_date_progresses = DmerstickerDateProgress.includes(:user).where(date: @month)
    else  
      @dmersticker_date_progresses = DmerstickerDateProgress.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @dmersticker_date_progresses_last_update = @dmersticker_date_progresses.maximum(:create_date)
    @dmersticker_date_progresses = @dmersticker_date_progresses.where(create_date: @dmersticker_date_progresses_last_update)

    if AirpaystickerDateProgress.where(date: @month).exists?
      @airpaysticker_date_progresses = AirpaystickerDateProgress.includes(:user).where(date: @month)
    else  
      @airpaysticker_date_progresses = AirpaystickerDateProgress.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @airpaysticker_date_progresses_last_update = @airpaysticker_date_progresses.maximum(:create_date)
    @airpaysticker_date_progresses = @airpaysticker_date_progresses.where(create_date: @airpaysticker_date_progresses_last_update)

    if OtherProductDateProgress.where(product_name: "ITSS").where(date: @month).exists?
      @itss_date_progresses = OtherProductDateProgress.where(product_name: "ITSS").includes(:user).where(date: @month)
    else  
      @itss_date_progresses = OtherProductDateProgress.where(product_name: "ITSS").includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @itss_date_progresses_last_update = @itss_date_progresses.maximum(:create_date)
    @itss_date_progresses = @itss_date_progresses.where(create_date: @itss_date_progresses_last_update)

    if OtherProductDateProgress.where(product_name: "UsenPay").where(date: @month).exists?
      @usen_pay_date_progresses = OtherProductDateProgress.where(product_name: "UsenPay").includes(:user).where(date: @month)
    else  
      @usen_pay_date_progresses = OtherProductDateProgress.where(product_name: "UsenPay").includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @usen_pay_date_progresses_last_update = @usen_pay_date_progresses.maximum(:create_date)
    @usen_pay_date_progresses = @usen_pay_date_progresses.where(create_date: @usen_pay_date_progresses_last_update)

    if CashDateProgress.where(date: @month).exists?
      @cash_date_progresses = CashDateProgress.where(date: @month)
    else  
      @cash_date_progresses = CashDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    end 
    @cash_date_progresses_last_update = @cash_date_progresses.maximum(:create_date)
    @cash_date_progresses = @cash_date_progresses.where(create_date: @cash_date_progresses_last_update)
    
    @users = User.where.not(position: "退職")

    @products = ["合計","dメル", "dメル専売","auPay", "PayPay", "楽天ペイ","AirPay","AirPayステッカー","UsenPay","会議用まとめ"]
    @fixed_sales = FixedSale.where(date: @month.all_month)
    @activity_bases = ActivityBase.includes(:user).where(date: @month.beginning_of_month)
    respond_to do |format|
      format.html
      format.xlsx do
        # ファイル名をここで指定する（動的にファイル名を変更できる）
        response.headers['Content-Disposition'] = "attachment; filename=#{@cash_date_progresses.first.date}実売資料.xlsx"
      end
    end

  end 

  def val_users
    @users = User.where.not(position: "退職").where(base_sub: "キャッシュレス")
    render partial: "val_users", locals: {}
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
    @cash_date_progress = CashDateProgress.where(date: @month.in_time_zone.all_month)
    @cash_date_progress = @cash_date_progress.where(create_date: @cash_date_progress.maximum(:create_date))
    @dmer_date_progress = DmerDateProgress.where(date: @month.in_time_zone.all_month)
    @dmer_date_progress = @dmer_date_progress.where(create_date: @dmer_date_progress.maximum(:create_date))
    bases = ["中部SS","関西SS","関東SS","九州SS","フェムト", "サミット", "退職","2次店"]
    head :no_content
    filename = "#{@month.month}月実売資料"
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
        result_attributes["dmer1_profit_current"] = dmer_progress.sum(:profit_current1)
        result_attributes["dmer1_profit_fin"] = dmer_progress.sum(:profit_fin1)
        csv << result_attributes.values_at(*columns)
      end
      # 全拠点
      result_attributes = {}
      result_attributes["base"] = "全拠点"
      result_attributes["average"] = 
        (@cash_date_progress.where("base LIKE ?","%SS%").sum(:profit_fin).to_f / 
        @cash_date_progress.where("base LIKE ?","%SS%").sum(:shift_schedule)).round()
      result_attributes["profit_current"] = @cash_date_progress.sum(:profit_current)
      result_attributes["profit_fin"] = @cash_date_progress.sum(:profit_fin)
      result_attributes["dmer1_profit_current"] = @dmer_date_progress.sum(:profit_current1)
      result_attributes["dmer1_profit_fin"] = @dmer_date_progress.sum(:profit_fin1)
      csv << result_attributes.values_at(*columns)
    end 
    create_csv(filename,csv)
  end

  def cash_valuation_csv_export 
    bases
    @cash_date_progress = CashDateProgress.where(date: @month.in_time_zone.all_month)
    @cash_date_progress = @cash_date_progress.where(create_date: @cash_date_progress.maximum(:create_date)).where(date: @cash_date_progress.maximum(:date))
    @dmer_date_progress = DmerDateProgress.where(date: @month.in_time_zone.all_month)
    @dmer_date_progress = @dmer_date_progress.where(create_date: @dmer_date_progress.maximum(:create_date)).where(date: @dmer_date_progress.maximum(:date))
    @dmer_senbai_date_progress = DmerSenbaiDateProgress.where(date: @month.in_time_zone.all_month)
    @dmer_senbai_date_progress = @dmer_senbai_date_progress.where(create_date: @dmer_senbai_date_progress.maximum(:create_date)).where(date: @dmer_senbai_date_progress.maximum(:date))
    @aupay_date_progress = AupayDateProgress.where(date: @month.in_time_zone.all_month)
    @aupay_date_progress = @aupay_date_progress.where(create_date: @aupay_date_progress.maximum(:create_date)).where(date: @aupay_date_progress.maximum(:date))
    @paypay_date_progress = PaypayDateProgress.where(date: @month.in_time_zone.all_month)
    @paypay_date_progress = @paypay_date_progress.where(create_date: @paypay_date_progress.maximum(:create_date)).where(date: @paypay_date_progress.maximum(:date))
    @rakuten_pay_date_progress = RakutenPayDateProgress.where(date: @month.in_time_zone.all_month)
    @rakuten_pay_date_progress = @rakuten_pay_date_progress.where(create_date: @rakuten_pay_date_progress.maximum(:create_date)).where(date: @rakuten_pay_date_progress.maximum(:date))
    @airpay_date_progress = AirpayDateProgress.where(date: @month.in_time_zone.all_month)
    @airpay_date_progress = @airpay_date_progress.where(create_date: @airpay_date_progress.maximum(:create_date)).where(date: @airpay_date_progress.maximum(:date))
    @demaekan_date_progress = DemaekanDateProgress.where(date: @month.in_time_zone.all_month)
    @demaekan_date_progress = @demaekan_date_progress.where(create_date: @demaekan_date_progress.maximum(:create_date)).where(date: @demaekan_date_progress.maximum(:date))
    @austicker_date_progress = AustickerDateProgress.where(date: @month.in_time_zone.all_month)
    @austicker_date_progress = @austicker_date_progress.where(create_date: @austicker_date_progress.maximum(:create_date)).where(date: @austicker_date_progress.maximum(:date))
    @dmersticker_date_progress = DmerstickerDateProgress.where(date: @month.in_time_zone.all_month)
    @dmersticker_date_progress = @dmersticker_date_progress.where(create_date: @dmersticker_date_progress.maximum(:create_date)).where(date: @dmersticker_date_progress.maximum(:date))
    @airpaysticker_date_progress = AirpaystickerDateProgress.where(date: @month.in_time_zone.all_month)
    @airpaysticker_date_progress = @airpaysticker_date_progress.where(create_date: @airpaysticker_date_progress.maximum(:create_date)).where(date: @airpaysticker_date_progress.maximum(:date))
    @itss_date_progress = OtherProductDateProgress.where(product_name: "ITSS").where(date: @month.in_time_zone.all_month)
    @itss_date_progress = @itss_date_progress.where(create_date: @itss_date_progress.maximum(:create_date)).where(date: @itss_date_progress.maximum(:date))
    @usen_date_progress  = OtherProductDateProgress.where(product_name: "UsenPay").where(date: @month.in_time_zone.all_month)
    @usen_date_progress = @usen_date_progress.where(create_date: @usen_date_progress.maximum(:create_date)).where(date: @usen_date_progress.maximum(:date))
    head :no_content
    filename = "評価売資料#{@month}"
    columns_ja = [
      "拠点", "ユーザー","役職", "予定シフト", "消化シフト", "現状評価売上","終着評価売",
      "dメル審査通過（終着）","dメルアクセプタンス審査通過（終着）","dメル２回目決済（終着）","auPay（終着）", "PayPay（終着）",
      "楽天ペイ（終着）","AirPay（終着）","出前館（終着）","auステッカー（終着）","dメルステッカー（終着）", "ITSS（終着）", "UsenPay（終着）","AirPayステッカー（終着）","戻入"
    ]
    columns = [
      "base", "user_name","post","shift_schedule", "shift_digestion", "valuation_current", "valuation_fin", 
      "dmer1_valuation_fin", "dmer2_valuation_fin", "dmer3_valuation_fin", "aupay_valuation_fin","paypay_valuation_fin",
      "rakuten_pay_valuation_fin","airpay_valuation_fin","demaekan_valuation_fin","austicker_valuation_fin","dmersticker_valuation_fin",
      "itss_valuation_fin","usen_valuation_fin","airpaysticker_valuation_fin","reversal_price"
    ]
    bom = "\uFEFF"
    csv = CSV.generate(bom) do |csv|
      csv << columns_ja
      @progress_bases.each do |base|
        CashDateProgress.where(date: @month.in_time_zone.all_month).where(create_date: @cash_date_progress.maximum(:create_date)).includes(:user).where(base: base).order("users.position_sub ASC").order("users.id ASC").group(:user_id).each do |cash_progress|
          @reversal_products = ReversalProduct.where(user_id: cash_progress.user_id).where(reversal_date: @month.all_month)
          result_attributes = {}
          result_attributes["base"] = base
          result_attributes["user_name"] = cash_progress.user.name
          result_attributes["post"] = cash_progress.user.position_sub
          result_attributes["shift_schedule"] = 
            @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:shift_schedule).to_i + 
            @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:shift_schedule_slmt).to_i
          result_attributes["shift_digestion"] = 
            @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:shift_digestion).to_i + 
            @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:shift_digestion_slmt).to_i
          result_attributes["valuation_current"] = 
            @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) + 
            @dmer_senbai_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) + 
            @aupay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) + 
            @paypay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) + 
            @rakuten_pay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) + 
            @airpay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) + 
            @demaekan_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) + 
            @austicker_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) + 
            @dmersticker_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) +
            @airpaysticker_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) +
            @usen_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current) +
            @itss_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_current)
          result_attributes["valuation_fin"] = 
            @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin1) + 
            @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin2) + 
            @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin3) + 
            @dmer_senbai_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) + 
            @aupay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) + 
            @paypay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) + 
            @rakuten_pay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) + 
            @airpay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) + 
            @demaekan_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) + 
            @austicker_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) + 
            @dmersticker_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) +
            @airpaysticker_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) +
            @usen_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) +
            @itss_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin) - 
            @reversal_products.where(user_id: cash_progress.user_id).sum(:price)
          result_attributes["dmer1_valuation_fin"] = @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin1) + @dmer_senbai_date_progress.sum(:valuation_fin1)
          result_attributes["dmer2_valuation_fin"] = @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin2) + @dmer_senbai_date_progress.sum(:valuation_fin2)
          result_attributes["dmer3_valuation_fin"] = @dmer_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin3) + @dmer_senbai_date_progress.sum(:valuation_fin3)
          result_attributes["aupay_valuation_fin"] = @aupay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin)
          result_attributes["paypay_valuation_fin"] = @paypay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin)
          result_attributes["rakuten_pay_valuation_fin"] = @rakuten_pay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin)
          result_attributes["airpay_valuation_fin"] = @airpay_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin)
          result_attributes["demaekan_valuation_fin"] = @demaekan_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin)
          result_attributes["austicker_valuation_fin"] = @austicker_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin)
          result_attributes["dmersticker_valuation_fin"] = @dmersticker_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin)
          result_attributes["airpaysticker_valuation_fin"] = @airpaysticker_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin)
          result_attributes["usen_valuation_fin"] = @usen_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin)
          result_attributes["itss_valuation_fin"] = @itss_date_progress.where(user_id: cash_progress.user_id).sum(:valuation_fin)
          result_attributes["reversal_price"] = @reversal_products.where(user_id: cash_progress.user_id).sum(:price)
          csv << result_attributes.values_at(*columns)
        end 
      end
    end 
    create_csv(filename,csv)
  end 

  def weekly_data
    bases
    @users = User.where(base_sub: "キャッシュレス").where.not(position: "退職")
    @shifts = Shift.where(start_time: @month.all_month).where(shift: "キャッシュレス新規")
    @results = Result.where(date: @month.all_month).where(shift: "キャッシュレス新規")
    @dmers = Dmer.where(date: @month.all_month)
    @airpays = Airpay.where(date: @month.all_month)
    @usen_pays = UsenPay.where(date: @month.all_month)

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

  def set_month
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
  end 
end
