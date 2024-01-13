module DmerSenbaiValuationCalc
  extend ActiveSupport::Concern
  include CalcDate

  # 実売 calc_valuationの下に配置
  # 各種獲得内訳（個人）
  def dmer_senbai_data(u_id)
    # 初期設定
    if @month.nil?
      @month = params[:month] ? Time.parse(params[:month]) : Date.today
    end
    @calc_periods = CalcPeriod.where(sales_category: "評価売")
    @basic_calc_data = @calc_periods.find_by(name: "各商材獲得")
    @start_date = start_date(@basic_calc_data)
    @end_date = end_date(@basic_calc_data)
    @dmer_senbai1_calc_data = @calc_periods.find_by(name: "dメル専売成果1")
    @dmer_senbai2_calc_data = @calc_periods.find_by(name: "dメル専売成果2")
    @dmer_senbai3_calc_data = @calc_periods.find_by(name: "dメル専売成果3")
    # 獲得者, 決済者, 2回目決済者
    @dmer_senbais = DmerSenbai.where(user_id: u_id) 
    @dmer_senbais_slmter = DmerSenbai.where(settlementer_id: u_id)
    @dmer_senbais_slmter2nd = DmerSenbai.where(settlementer2nd_id: u_id)
    # 審査通過
    @dmer_senbai_done = 
      @dmer_senbais
      .where(industry_status: "OK")
      .where(app_check: "OK")
      .where.not(dup_check: "重複")
      .where(partner_status: "Active")
      .where(status: "審査OK")
    # 決済内訳
    @dmers_senbai_slmt_done = @dmer_senbai_done.where(status_settlement: "完了")
    @dmers_senbai_slmt_def = @dmer_senbai_done.where(status_settlement: "決済不備")
    @dmers_senbai_slmt_pic_def = @dmer_senbai_done.where(status_settlement: "写真不備")
    # 不備・NG
    @dmer_senbais_def = 
      @dmer_senbais.where(status: "審査NG")
      .or(@dmer_senbais.where(status: "申込取消"))
      .or(@dmer_senbais.where(status: "不備対応中"))
      .or(@dmer_senbais.where(status: "社内確認中"))
      .or(@dmer_senbais.where(industry_status: "NG"))
      .or(@dmer_senbais.where(app_check: "NG"))
      .or(@dmer_senbais.where(dup_check: "重複"))
      .or(@dmer_senbais.where.not(partner_status: "Active"))

    # アクセプタンス合格
    def dmer_senbai_slmt_done(dmer_senbai_data)
      dmer_senbai_data
      .where(industry_status: "OK")
      .where(app_check: "OK")
      .where.not(dup_check: "重複")
      .where(partner_status: "Active")
      .where(status: "審査OK")
      .where(status_settlement: "完了")
      .where(picture_check: "合格")
    end 
    @dmer_senbai_done_slmter = dmer_senbai_slmt_done(@dmer_senbais_slmter)
    @dmer_senbai_done_slmter2nd = dmer_senbai_slmt_done(@dmer_senbais_slmter2nd)
    #期間内で獲得した情報
    @dmer_senbais_period = 
      @dmer_senbais.where(date: @start_date..@end_date)
    #期間内の不備・NGの件数
    # ★成果
    # 審査完了（獲得者）
    @dmer_senbai_result1 = 
      @dmer_senbai_done.where(result_point: start_date(@dmer_senbai1_calc_data)..end_date(@dmer_senbai1_calc_data))
    # アクセプタンス合格（決済対応者）
    @dmer_senbai_result2 = 
      @dmer_senbai_done_slmter
      .where(result_point: start_date(@dmer_senbai2_calc_data)..end_date(@dmer_senbai2_calc_data))
      .where(picture_check_date: ..end_date(@dmer_senbai2_calc_data))
      .or(
        @dmer_senbai_done_slmter
        .where(result_point: ..end_date(@dmer_senbai2_calc_data))
        .where(picture_check_date: start_date(@dmer_senbai2_calc_data)..end_date(@dmer_senbai2_calc_data))

      )
    # 2回目決済（2回目決済者）
    @dmer_senbai_result3 = 
    @dmer_senbai_done_slmter2nd
    .where(result_point: start_date(@dmer_senbai3_calc_data)..end_date(@dmer_senbai3_calc_data))
    .where(picture_check_date: ..end_date(@dmer_senbai3_calc_data))
    .where(settlement_second: ..end_date(@dmer_senbai3_calc_data))
      .or(
        @dmer_senbai_done_slmter2nd.where(result_point: ..end_date(@dmer_senbai3_calc_data))
        .where(picture_check_date: start_date(@dmer_senbai3_calc_data)..end_date(@dmer_senbai3_calc_data))
        .where(settlement_second: ..end_date(@dmer_senbai3_calc_data))
      )
      .or(
        @dmer_senbai_done_slmter2nd.where(result_point: ..end_date(@dmer_senbai3_calc_data))
        .where(picture_check_date: ..end_date(@dmer_senbai3_calc_data))
        .where(settlement_second: start_date(@dmer_senbai3_calc_data)..end_date(@dmer_senbai3_calc_data))
      )
      
  end 

end 