class SummitDateProgressesController < ApplicationController

  def index 
    @users = User.where(base_sub: "サミット")
    # 大元
    @bases = ["中部SS", "関西SS", "関東SS"]
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @billing_year = @month.year

    @year_month = @month.strftime("%Y年%m月")

    @year_month_prev = @month.prev_month.strftime("%Y年%m月")

    @year_parse = @month.to_date.all_year

    @billings = SummitBillingAmount.where(billing_date: @year_month)
    @billings_prev = SummitBillingAmount.where(billing_date: @year_month_prev)
    @users_data = User.all
    @summit_users = Summit.includes(:user).group(:user_id)

    @month_metered_all = 
      SummitBillingAmount.where("contract_type LIKE ?","%従量%").where("billing_date LIKE ?","%#{@billing_year}%")
      .select(
        :first_flag,:base,:billing_date, :contract_type, :total_use, :billing_amount, :commission,:user_id
      )
    @metered_group = @month_metered_all.group_by {|m| m[:user_id]}
    # @commission_group = @month_metered_all.group(:user_id,:billing_date).sum(:commission)
    @month_metered = SummitBillingAmount.where(first_flag: "過去発行済").where("contract_type LIKE ?","%従量%").where("billing_date LIKE ?","%#{@billing_year}%")
    @month_low_voltage = SummitBillingAmount.where(first_flag: "過去発行済").where(contract_type: "低圧電力").where("billing_date LIKE ?","%#{@billing_year}%")

    # 拠点別当月
    @billings_chubu = @billings.includes(:user).where(base: "中部SS")
    @billings_kansai = @billings.includes(:user).where(base: "関西SS")
    @billings_kanto = @billings.includes(:user).where(base: "関東SS")
    @billings_kyushu = @billings.includes(:user).where(base: "九州SS")
    @current_arry = [@billings_chubu,@billings_kansai,@billings_kanto,@billings_kyushu]
    

    @users_all = @billings.includes(:user).group(:user_id)
    @users_chubu = @billings.includes(:user).where(base: "中部SS").group(:user_id)
    @users_kansai = @billings.includes(:user).where(base: "関西SS").group(:user_id)
    @users_kanto = @billings.includes(:user).where(base: "関東SS").group(:user_id)
    @users_kyushu = @billings.includes(:user).where(base: "九州SS").group(:user_id)
    # 拠点別前月
    @billings_prev_chubu = @billings_prev.includes(:user).where(base: "中部SS")
    @billings_prev_kansai = @billings_prev.includes(:user).where(base: "関西SS")
    @billings_prev_kanto = @billings_prev.includes(:user).where(base: "関東SS")
    @billings_prev_kyushu = @billings_prev.includes(:user).where(base: "九州SS")
    @prev_arry = [@billings_prev_chubu,@billings_prev_kansai,@billings_prev_kanto,@billings_prev_kyushu]
    
    
    @commission_ave = [
      {
        name: "従量電灯（合計）", data: SummitBillingAmount.where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where("contract_type LIKE ?","%従量%").group(:billing_date).average(:commission)
      },
      {
        name: "従量電灯（5%）", data: SummitBillingAmount.where(rate: 5).where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where("contract_type LIKE ?","%従量%").group(:billing_date).average(:commission)
      },
      {
        name: "従量電灯（7%）", data: SummitBillingAmount.where(rate: 7).where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where("contract_type LIKE ?","%従量%").group(:billing_date).average(:commission)
      },
      {
        name: "低圧電力", data: SummitBillingAmount.where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where(contract_type: "低圧電力").group(:billing_date).order(:billing_date).average(:commission)
      },
    ]
    
    @commission_ave_area = [
      {
        name: "従量電灯（関西SS）", data: SummitBillingAmount.where(base: "関西SS").where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where("contract_type LIKE ?","%従量%").group(:billing_date).average(:commission)
      },
      {
        name: "従量電灯（関東SS）", data: SummitBillingAmount.where(base: "関東SS").where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where("contract_type LIKE ?","%従量%").group(:billing_date).average(:commission)
      },
      {
        name: "従量電灯（中部SS）", data: SummitBillingAmount.where(base: "中部SS").where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where("contract_type LIKE ?","%従量%").group(:billing_date).average(:commission)
      },
    ]

    @billing_amount_ave = [
      {
        name: "従量電灯", data: SummitBillingAmount.where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where("contract_type LIKE ?","%従量%").group(:billing_date).average(:billing_amount)
      },
      {
        name: "低圧電力", data: SummitBillingAmount.where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where(contract_type: "低圧電力").group(:billing_date).average(:billing_amount)
      },
    ]
    @metered_billing_amount_ave = 
    @tota_use_ave_graph = [
      {
        name: "従量電灯", data: SummitBillingAmount.where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where("contract_type LIKE ?","%従量%").group(:billing_date).average(:total_use)
      },
      {
        name: "低圧電力", data: SummitBillingAmount.where(first_flag: "過去発行済").where("billing_date LIKE ?","%#{@billing_year}%").where(contract_type: "低圧電力").group(:billing_date).average(:total_use)
      },
    ]

    

    if  @billings.present?
      @billings_commission = [
        {
          name: "全体手数料", data: SummitBillingAmount.where("billing_date LIKE ?","%#{@billing_year}%").group(:billing_date).sum(:commission)
        },
        {
          name: "中部SS手数料", data: SummitBillingAmount.where(base: "中部SS").where("billing_date LIKE ?","%#{@billing_year}%").group(:billing_date).sum(:commission)
        },
        {
          name: "関西SS手数料", data: SummitBillingAmount.where(base: "関西SS").where("billing_date LIKE ?","%#{@billing_year}%").group(:billing_date).sum(:commission)
        },
        {
          name: "関東SS手数料", data: SummitBillingAmount.where(base: "関東SS").where("billing_date LIKE ?","%#{@billing_year}%").group(:billing_date).sum(:commission)
        },
        {
          name: "九州SS手数料", data: SummitBillingAmount.where(base: "九州SS").where("billing_date LIKE ?","%#{@billing_year}%").group(:billing_date).sum(:commission)
        },
      ]

      @billings_metered_data = SummitBillingAmount.where("contract_type LIKE ?", "%従量%").where("billing_date LIKE ?","%#{@billing_year}%")
      @billings_metered = [
        {
          name: "全体従量件数", data: @billings_metered_data.group(:billing_date).count
        },
        {
          name: "中部SS従量件数", data: @billings_metered_data.where(base: "中部SS").group(:billing_date).count
        },
        {
          name: "関西SS従量件数", data: @billings_metered_data.where(base: "関西SS").group(:billing_date).count
        },
        {
          name: "関東SS従量件数", data: @billings_metered_data.where(base: "関東SS").group(:billing_date).count
        },
        {
          name: "九州SS従量件数", data: @billings_metered_data.where(base: "九州SS").group(:billing_date).count
        },
      ]

      @billings_low_voltage = [
        {
          name: "全体低圧電力件数", data: SummitBillingAmount.where(contract_type: "低圧電力").where("billing_date LIKE ?","%#{@billing_year}%").group(:billing_date).count
        },
        {
          name: "中部SS低圧電力件数", data: SummitBillingAmount.where(base: "中部SS").where(contract_type: "低圧電力").where("billing_date LIKE ?","%#{@billing_year}%").group(:billing_date).count
        },
        {
          name: "関西SS低圧電力件数", data: SummitBillingAmount.where(base: "関西SS").where(contract_type: "低圧電力").where("billing_date LIKE ?","%#{@billing_year}%").group(:billing_date).count
        },
        {
          name: "関東SS低圧電力件数", data: SummitBillingAmount.where(base: "関東SS").where(contract_type: "低圧電力").where("billing_date LIKE ?","%#{@billing_year}%").group(:billing_date).count
        },
        {
          name: "九州SS低圧電力件数", data: SummitBillingAmount.where(base: "九州SS").where(contract_type: "低圧電力").where("billing_date LIKE ?","%#{@billing_year}%").group(:billing_date).count
        },
      ]
    else
    end
  end 

  def show
  end 

end
