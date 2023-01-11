class SummitDateProgressesController < ApplicationController

  def index 
    # 大元
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @year_parse = @month.to_date.all_year
    @summits = Summit.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    @billings = SummitBillingAmount.where(payment_date: @month.beginning_of_month..@month.end_of_month)
    @billings_prev = SummitBillingAmount.where(payment_date: @month.prev_month.beginning_of_month..@month.prev_month.end_of_month)
    @users = User.all
    @summit_users = Summit.includes(:user).group(:user_id)

    @month_metered_len = SummitBillingAmount.where(payment_date: @year_parse).group(:user_id,"Month(payment_date)")

    # 拠点別当月
    @billings_chubu = @billings.includes(:user).where(user: {base: "中部SS"})
    @billings_kansai = @billings.includes(:user).where(user: {base: "関西SS"})
    @billings_kanto = @billings.includes(:user).where(user: {base: "関東SS"})
    @billings_kyushu = @billings.includes(:user).where(user: {base: "九州SS"})
    @current_arry = [@billings_chubu,@billings_kansai,@billings_kanto,@billings_kyushu]
    

    @users_all = @billings.includes(:user).group(:user_id)
    @users_chubu = @billings.includes(:user).where(user: {base: "中部SS"}).group(:user_id)
    @users_kansai = @billings.includes(:user).where(user: {base: "関西SS"}).group(:user_id)
    @users_kanto = @billings.includes(:user).where(user: {base: "関東SS"}).group(:user_id)
    @users_kyushu = @billings.includes(:user).where(user: {base: "九州SS"}).group(:user_id)
    # 拠点別前月
    @billings_prev_chubu = @billings_prev.includes(:user).where(user: {base: "中部SS"})
    @billings_prev_kansai = @billings_prev.includes(:user).where(user: {base: "関西SS"})
    @billings_prev_kanto = @billings_prev.includes(:user).where(user: {base: "関東SS"})
    @billings_prev_kyushu = @billings_prev.includes(:user).where(user: {base: "九州SS"})
    @prev_arry = [@billings_prev_chubu,@billings_prev_kansai,@billings_prev_kanto,@billings_prev_kyushu]

    
    @metered_ave = SummitBillingAmount.where(payment_date: @year_parse).where("contract_type LIKE ?","%従量%").group("Month(payment_date)").average(:commission)
    @metered_billing_amount_ave = SummitBillingAmount.where(payment_date: @year_parse).where("contract_type LIKE ?","%従量%").group("Month(payment_date)").average(:billing_amount)
    @metered_total_use_ave = SummitBillingAmount.where(payment_date: @year_parse).where("contract_type LIKE ?","%従量%").group("Month(payment_date)").average(:total_use)

    if  @billings.present?
      @billings_commission = [
        {
          name: "全体手数料", data: SummitBillingAmount.where(payment_date: @year_parse).group("Month(payment_date)").sum(:commission)
        },
        {
          name: "中部SS手数料", data: SummitBillingAmount.includes(:user).where(user: {base: "中部SS"}).where(payment_date: @year_parse).group("Month(payment_date)").sum(:commission)
        },
        {
          name: "関西SS手数料", data: SummitBillingAmount.includes(:user).where(user: {base: "関西SS"}).where(payment_date: @year_parse).group("Month(payment_date)").sum(:commission)
        },
        {
          name: "関東SS手数料", data: SummitBillingAmount.includes(:user).where(user: {base: "関東SS"}).where(payment_date: @year_parse).group("Month(payment_date)").sum(:commission)
        },
        {
          name: "九州SS手数料", data: SummitBillingAmount.includes(:user).where(user: {base: "九州SS"}).where(payment_date: @year_parse).group("Month(payment_date)").sum(:commission)
        },
      ]

      @billings_metered = [
        {
          name: "全体従量件数", data: SummitBillingAmount.where("contract_type LIKE ?", "%従量%").where(payment_date: @year_parse).group("Month(payment_date)").count
        },
        {
          name: "中部SS従量件数", data: SummitBillingAmount.includes(:user).where(user: {base: "中部SS"}).where("contract_type LIKE ?", "%従量%").where(payment_date: @year_parse).group("Month(payment_date)").count
        },
        {
          name: "関西SS従量件数", data: SummitBillingAmount.includes(:user).where(user: {base: "関西SS"}).where("contract_type LIKE ?", "%従量%").where(payment_date: @year_parse).group("Month(payment_date)").count
        },
        {
          name: "関東SS従量件数", data: SummitBillingAmount.includes(:user).where(user: {base: "関東SS"}).where("contract_type LIKE ?", "%従量%").where(payment_date: @year_parse).group("Month(payment_date)").count
        },
        {
          name: "九州SS従量件数", data: SummitBillingAmount.includes(:user).where(user: {base: "九州SS"}).where("contract_type LIKE ?", "%従量%").where(payment_date: @year_parse).group("Month(payment_date)").count
        },
      ]

      @billings_low_voltage = [
        {
          name: "全体低圧電力件数", data: SummitBillingAmount.where(contract_type: "低圧電力").where(payment_date: @year_parse).group("Month(payment_date)").count
        },
        {
          name: "中部SS低圧電力件数", data: SummitBillingAmount.includes(:user).where(user: {base: "中部SS"}).where(contract_type: "低圧電力").where(payment_date: @year_parse).group("Month(payment_date)").count
        },
        {
          name: "関西SS低圧電力件数", data: SummitBillingAmount.includes(:user).where(user: {base: "関西SS"}).where(contract_type: "低圧電力").where(payment_date: @year_parse).group("Month(payment_date)").count
        },
        {
          name: "関東SS低圧電力件数", data: SummitBillingAmount.includes(:user).where(user: {base: "関東SS"}).where(contract_type: "低圧電力").where(payment_date: @year_parse).group("Month(payment_date)").count
        },
        {
          name: "九州SS低圧電力件数", data: SummitBillingAmount.includes(:user).where(user: {base: "九州SS"}).where(contract_type: "低圧電力").where(payment_date: @year_parse).group("Month(payment_date)").count
        },
      ]
    else
    end
  end 

  def show
  end 

end
