class ResultsBaseValuationsController < ApplicationController
  # 拠点別利益表
  before_action :set_data

  def index #メインページ

  end 

  def valuation 
    render partial: "valuation", locals: {} # を遅延ロード
  end 

  private 
  def set_data
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @base = params[:base]
    @results = Result.includes(:user,:result_cash).where(user: {base: @base}).where(date: @month.all_month)
    @users = User.where(base: @base).where(base_sub: "キャッシュレス").where.not(position: "退職").order("users.position_sub ASC").order("users.id ASC")
    @cash_date_progress = CashDateProgress.includes(:user).where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @cash_date_progress = @cash_date_progress.where(date: @cash_date_progress.maximum(:date)).where(create_date: @cash_date_progress.maximum(:create_date))
    @dmer_date_progress = DmerDateProgress.includes(:user).where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @dmer_date_progress = @dmer_date_progress.where(date: @dmer_date_progress.maximum(:date)).where(create_date: @dmer_date_progress.maximum(:create_date))
    @aupay_date_progress = AupayDateProgress.includes(:user).where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @aupay_date_progress = @aupay_date_progress.where(date: @aupay_date_progress.maximum(:date)).where(create_date: @aupay_date_progress.maximum(:create_date))
    @rakuten_pay_date_progress = RakutenPayDateProgress.includes(:user).where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @rakuten_pay_date_progress = @rakuten_pay_date_progress.where(date: @rakuten_pay_date_progress.maximum(:date)).where(create_date: @rakuten_pay_date_progress.maximum(:create_date))
    @airpay_date_progress = AirpayDateProgress.includes(:user).where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @airpay_date_progress = @airpay_date_progress.where(date: @airpay_date_progress.maximum(:date)).where(create_date: @airpay_date_progress.maximum(:create_date))
    @paypay_date_progress = PaypayDateProgress.includes(:user).where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @paypay_date_progress = @paypay_date_progress.where(date: @paypay_date_progress.maximum(:date)).where(create_date: @paypay_date_progress.maximum(:create_date))
    @airpaysticker_date_progress = AirpaystickerDateProgress.includes(:user).where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @airpaysticker_date_progress = @airpaysticker_date_progress.where(date: @airpaysticker_date_progress.maximum(:date)).where(create_date: @airpaysticker_date_progress.maximum(:create_date))
    @austicker_date_progress = AustickerDateProgress.includes(:user).where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @austicker_date_progress = @austicker_date_progress.where(date: @austicker_date_progress.maximum(:date)).where(create_date: @austicker_date_progress.maximum(:create_date))
    @dmersticker_date_progress = DmerstickerDateProgress.includes(:user).where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @dmersticker_date_progress = @dmersticker_date_progress.where(date: @dmersticker_date_progress.maximum(:date)).where(create_date: @dmersticker_date_progress.maximum(:create_date))
    @demaekan_date_progress = DmerstickerDateProgress.includes(:user).where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @demaekan_date_progress = @demaekan_date_progress.where(date: @demaekan_date_progress.maximum(:date)).where(create_date: @demaekan_date_progress.maximum(:create_date))
    @itss_date_progress = OtherProductDateProgress.includes(:user).where(product_name: "ITSS").where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @itss_date_progress = @itss_date_progress.where(date: @itss_date_progress.maximum(:date)).where(create_date: @itss_date_progress.maximum(:create_date))
    
    @usen_pay_date_progress = OtherProductDateProgress.includes(:user).where(product_name: "UsenPay").where(date: @month.all_month).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @usen_pay_date_progress = @usen_pay_date_progress.where(date: @usen_pay_date_progress.maximum(:date)).where(create_date: @usen_pay_date_progress.maximum(:create_date))
  end 
end
