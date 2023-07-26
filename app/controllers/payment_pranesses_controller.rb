class PaymentPranessesController < ApplicationController
  before_action :set_year_val_params, only: [:year_valuation,:year_val_price, :year_val_len]
  before_action :set_year_profit_params, only: [:year_profit,:year_profit_price, :year_profit_len]
  def index 
    @q = PaymentPraness.ransack(params[:q])
    @payment_pranesses = 
      if params[:q].nil?
        PaymentPraness.none 
      else
        @q.result(distinct: false)
      end
      @payment_pranesses_data = @payment_pranesses.page(params[:page]).per(100)
  end 

  # 年間実売
  def year_profit

  end

  def year_profit_price
    render partial: "year_profit_price", locals: {}
  end 

  def year_profit_len
    render partial: "year_profit_len", locals: {}
  end 
  # /年間実売

  # 年間評価売
  def year_valuation

  end

  def year_val_price
    render partial: "year_val_price", locals: {}
  end 

  def year_val_len
    render partial: "year_val_len", locals: {}
  end 
  # /年間評価売
  def not_payment
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @not_payments = PaymentPraness.where(status: "入金待ち").includes(:praness)
    @already_payments = PaymentPraness.where(status: "完了").includes(:praness)
    if params[:payment_date].present? 
      @not_payments = @not_payments.where(payment_date: params[:payment_date])
    end 
    if params[:payment_schedule_start].present? && params[:payment_schedule_end].present?
      @not_payments = @not_payments.where(payment_schedule: params[:payment_schedule_start]..params[:payment_schedule_end])
    elsif params[:payment_schedule_start].present? && params[:payment_schedule_end].blank?
      @not_payments = @not_payments.where(payment_schedule: params[:payment_schedule_start]..)
    elsif params[:payment_schedule_start].blank? && params[:payment_schedule_end].present?
      @not_payments = @not_payments.where(payment_schedule: ..params[:payment_schedule_end])
    end 
  end 


  def import 
    if params[:file].present?
      if PaymentPraness.csv_check(params[:file]).present?
        redirect_to payment_pranesses_path , alert: "エラーが発生したため中断しました#{PaymentPraness.csv_check(params[:file])}"
      else
        message = PaymentPraness.import(params[:file]) 
        redirect_to payment_pranesses_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to payment_pranesses_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  private 
  def set_year_profit_params
    @display_params = params[:display]
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @payment_period = @month.prev_year..@month
    @billings = PaymentPraness.includes(:praness).where(payment_date: @payment_period).order(:payment_date)
    @options = PranessOption.where(payment_date: @payment_period).order(:payment_date)
    @pranesses = Praness.includes(:user).all
  end 

  def set_year_val_params
    @display_params = params[:display]
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @payment_period = @month.prev_year..@month
    @billings = PaymentPraness.includes(:praness).where(payment_date: @payment_period).order(:payment_date)
    @pranesses = Praness.includes(:user).where(user: {team: "ぷらねす"})
    @options = PranessOption.where(payment_date: @payment_period).order(:payment_date)
    # 単価
    @praness_valuation = 1000
    @option_valuation = 300
  end 

end
