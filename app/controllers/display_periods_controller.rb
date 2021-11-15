class DisplayPeriodsController < ApplicationController

  def index 
    @display_period = DisplayPeriod.new
    @display_period_1 = DisplayPeriod.first if DisplayPeriod.first.present?
    @results = Result.all
    if   DisplayPeriod.all.length != 0
  # 訪問員数
      @cash_period = this_period(@results,@display_period_1.start_period_01,@display_period_1.end_period_01).includes(:user)
      @cash_period_prev_week = this_period(@results,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days)).includes(:user)
      @casa_period = this_period(@results,@display_period_1.start_period_02,@display_period_1.end_period_02).includes(:user)
      @casa_period_prev_week = this_period(@results,@display_period_1.start_period_02.ago(7.days),@display_period_1.end_period_02.ago(7.days)).includes(:user)
          @chubu_cash_persons = @cash_period.group(:user_id).where(user: {base: "中部SS",base_sub: "キャッシュレス"})
          @chubu_casa_persons = @casa_period.group(:user_id).where(user: {base: "中部SS",base_sub: "フェムト"})
          @kanto_cash_persons = @cash_period.group(:user_id).where(user: {base: "関東SS",base_sub: "キャッシュレス"})
          @kanto_casa_persons = @casa_period.group(:user_id).where(user: {base: "関東SS",base_sub: "フェムト"})
          @kansai_cash_persons = @cash_period.group(:user_id).where(user: {base: "関西SS",base_sub: "キャッシュレス"})
          @kansai_casa_persons = @casa_period.group(:user_id).where(user: {base: "関西SS",base_sub: "フェムト"})
  # 予定シフト
    @cash_shift = Shift.where(start_time: @display_period_1.start_period_01..@display_period_1.end_period_01).includes(:user)
    @casa_shift = Shift.where(start_time: @display_period_1.start_period_02..@display_period_1.end_period_02).includes(:user)
    @chubu_cash_shifts = @cash_shift.where(user: {base: "中部SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規").or(@cash_shift.where(user: {base: "中部SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済"))
    @chubu_casa_shifts = @cash_shift.where(user: {base: "中部SS",base_sub: "フェムト"}).where(shift: "楽天フェムト新規").or(@cash_shift.where(user: {base: "中部SS",base_sub: "フェムト"}).where(shift: "楽天フェムト設置"))
    @kanto_cash_shifts = @cash_shift.where(user: {base: "関東SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規").or(@cash_shift.where(user: {base: "関東SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済"))
    @kanto_casa_shifts = @cash_shift.where(user: {base: "関東SS",base_sub: "フェムト"}).where(shift: "楽天フェムト新規").or(@cash_shift.where(user: {base: "関東SS",base_sub: "フェムト"}).where(shift: "楽天フェムト設置"))
    @kansai_cash_shifts = @cash_shift.where(user: {base: "関西SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規").or(@cash_shift.where(user: {base: "関西SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済"))
    @kansai_casa_shifts = @cash_shift.where(user: {base: "関西SS",base_sub: "フェムト"}).where(shift: "楽天フェムト新規").or(@cash_shift.where(user: {base: "関西SS",base_sub: "フェムト"}).where(shift: "楽天フェムト設置"))
  # 消化シフト
    @chubu_cash_shift_digestion = @cash_period.where(user: {base: "中部SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規").or(@cash_period.where(user: {base: "中部SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済"))
    @chubu_casa_shift_digestion = @casa_period.where(user: {base: "中部SS",base_sub: "フェムト"}).where(shift: "楽天フェムト新規").or(@cash_period.where(user: {base: "中部SS",base_sub: "キャッシュレス"}).where(shift: "楽天フェムト設置"))
    @kanto_cash_shift_digestion = @cash_period.where(user: {base: "関東SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規").or(@cash_period.where(user: {base: "関東SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済"))
    @kanto_casa_shift_digestion = @casa_period.where(user: {base: "関東SS",base_sub: "フェムト"}).where(shift: "楽天フェムト新規").or(@cash_period.where(user: {base: "関東SS",base_sub: "キャッシュレス"}).where(shift: "楽天フェムト設置"))
    @kansai_cash_shift_digestion = @cash_period.where(user: {base: "関西SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規").or(@cash_period.where(user: {base: "関西SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済"))
    @kansai_casa_shift_digestion = @casa_period.where(user: {base: "関西SS",base_sub: "フェムト"}).where(shift: "楽天フェムト新規").or(@cash_period.where(user: {base: "関西SS",base_sub: "キャッシュレス"}).where(shift: "楽天フェムト設置"))
  # 消化シフト（先週）
    @chubu_cash_shift_digestion_prev_week = @cash_period_prev_week.where(user: {base: "中部SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規").or(@cash_period_prev_week.where(user: {base: "中部SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済"))
    @chubu_casa_shift_digestion_prev_week = @casa_period_prev_week.where(user: {base: "中部SS",base_sub: "フェムト"}).where(shift: "楽天フェムト新規").or(@cash_period_prev_week.where(user: {base: "中部SS",base_sub: "キャッシュレス"}).where(shift: "楽天フェムト設置"))
    @kanto_cash_shift_digestion_prev_week = @cash_period_prev_week.where(user: {base: "関東SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規").or(@cash_period_prev_week.where(user: {base: "関東SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済"))
    @kanto_casa_shift_digestion_prev_week = @casa_period_prev_week.where(user: {base: "関東SS",base_sub: "フェムト"}).where(shift: "楽天フェムト新規").or(@cash_period_prev_week.where(user: {base: "関東SS",base_sub: "キャッシュレス"}).where(shift: "楽天フェムト設置"))
    @kansai_cash_shift_digestion_prev_week = @cash_period_prev_week.where(user: {base: "関西SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規").or(@cash_period_prev_week.where(user: {base: "関西SS",base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済"))
    @kansai_casa_shift_digestion_prev_week = @casa_period_prev_week.where(user: {base: "関西SS",base_sub: "フェムト"}).where(shift: "楽天フェムト新規").or(@cash_period_prev_week.where(user: {base: "関西SS",base_sub: "キャッシュレス"}).where(shift: "楽天フェムト設置"))
  # 中部
    # 現状売上
    # dメル
      @chubu_dmer_users = Dmer.includes(:user).where(user: {base: "中部SS"})
      @chubu_dmer_this_period = this_period(@chubu_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_dmer_out_period =  out_period(@chubu_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_dmer_inc_period =  inc_period(@chubu_dmer_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_dmer_dec_period =  dec_period(@chubu_dmer_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_dmer_def_period =  def_period(@chubu_dmer_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      
      @chubu_dmer_slmt_this_period = slmt_this_period(@chubu_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_dmer_slmt_out_period = slmt_out_period(@chubu_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_dmer_slmt_inc_period = slmt_inc_period(@chubu_dmer_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_dmer_slmt_dec_period = slmt_dec_period(@chubu_dmer_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_dmer_slmt_def_period = slmt_def_period(@chubu_dmer_slmt_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)

    # 獲得件数
      @chubu_dmers_length = cash_length(@chubu_dmer_this_period,@chubu_dmer_def_period,@chubu_dmer_inc_period, @chubu_dmer_dec_period)
      @chubu_dmers_slmt_length = cash_length(@chubu_dmer_slmt_this_period,@chubu_dmer_slmt_def_period,@chubu_dmer_slmt_inc_period, @chubu_dmer_slmt_dec_period)
    # 評価売
      @chubu_dmer_valuation = @chubu_dmer_this_period.sum(:valuation_new) - @chubu_dmer_def_period.sum(:valuation_new) +
                              @chubu_dmer_inc_period.sum(:valuation_new) - @chubu_dmer_dec_period.sum(:valuation_new)
      @chubu_dmer_slmt_valuation = @chubu_dmer_slmt_this_period.sum(:valuation_settlement) -
                                  @chubu_dmer_slmt_def_period.sum(:valuation_settlement) +
                                  @chubu_dmer_slmt_inc_period.sum(:valuation_settlement) - 
                                  @chubu_dmer_slmt_dec_period.sum(:valuation_settlement)
    # 実売
      @chubu_dmer_profit = @chubu_dmer_this_period.sum(:profit_new) - @chubu_dmer_def_period.sum(:profit_new) +
                              @chubu_dmer_inc_period.sum(:profit_new) - @chubu_dmer_dec_period.sum(:profit_new)
      @chubu_dmer_slmt_profit = @chubu_dmer_slmt_this_period.sum(:profit_settlement) -
                                  @chubu_dmer_slmt_def_period.sum(:profit_settlement) +
                                  @chubu_dmer_slmt_inc_period.sum(:profit_settlement) - 
                                  @chubu_dmer_slmt_dec_period.sum(:profit_settlement)
    # aupay
      @chubu_aupay_users = Aupay.includes(:user).where(user: {base: "中部SS"})
      @chubu_aupay_this_period = this_period(@chubu_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_aupay_out_period =  out_period(@chubu_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_aupay_inc_period =  inc_period(@chubu_aupay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_aupay_dec_period =  dec_period(@chubu_aupay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_aupay_def_period =  def_period(@chubu_aupay_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      
      @chubu_aupay_slmt_this_period = slmt_this_period(@chubu_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_aupay_slmt_out_period = slmt_out_period(@chubu_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_aupay_slmt_inc_period = slmt_inc_period(@chubu_aupay_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_aupay_slmt_dec_period = slmt_dec_period(@chubu_aupay_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_aupay_slmt_def_period = slmt_def_period(@chubu_aupay_slmt_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
    # 獲得件数
      @chubu_aupays_length = cash_length(@chubu_aupay_this_period,@chubu_aupay_def_period,@chubu_aupay_inc_period, @chubu_aupay_dec_period)
      @chubu_aupays_slmt_length = cash_length(@chubu_aupay_slmt_this_period,@chubu_aupay_slmt_def_period,@chubu_aupay_slmt_inc_period, @chubu_aupay_slmt_dec_period)
    # 評価売
      @chubu_aupay_valuation = @chubu_aupay_this_period.sum(:valuation_new) - @chubu_aupay_def_period.sum(:valuation_new) +
                              @chubu_aupay_inc_period.sum(:valuation_new) - @chubu_aupay_dec_period.sum(:valuation_new)
      @chubu_aupay_slmt_valuation = @chubu_aupay_slmt_this_period.sum(:valuation_settlement) -
                                  @chubu_aupay_slmt_def_period.sum(:valuation_settlement) +
                                  @chubu_aupay_slmt_inc_period.sum(:valuation_settlement) - 
                                  @chubu_aupay_slmt_dec_period.sum(:valuation_settlement)
      # 実売
      @chubu_aupay_profit = @chubu_aupay_this_period.sum(:profit_new) - @chubu_aupay_def_period.sum(:profit_new) +
                              @chubu_aupay_inc_period.sum(:profit_new) - @chubu_aupay_dec_period.sum(:profit_new)
      @chubu_aupay_slmt_profit = @chubu_aupay_slmt_this_period.sum(:profit_settlement) -
                                  @chubu_aupay_slmt_def_period.sum(:profit_settlement) +
                                  @chubu_aupay_slmt_inc_period.sum(:profit_settlement) - 
                                  @chubu_aupay_slmt_dec_period.sum(:profit_settlement)
    # PayPay
      @chubu_paypay_users = Paypay.includes(:user).where(user: {base: "中部SS"})
      @chubu_paypay_this_period = this_period(@chubu_paypay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_paypay_def_period = def_period(@chubu_paypay_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      # 獲得件数
      @chubu_paypays_length = @chubu_paypay_this_period.length - @chubu_paypay_def_period.length
    # 評価売
      @chubu_paypay_valuation = @chubu_paypay_this_period.sum(:valuation) - @chubu_paypay_def_period.sum(:valuation)
    # 実売
      @chubu_paypay_profit = @chubu_paypay_this_period.sum(:profit) - @chubu_paypay_def_period.sum(:profit)
    # 楽天ペイ
      @chubu_rakuten_pay_users = RakutenPay.includes(:user).where(user: {base: "中部SS"})
      @chubu_rakuten_pay_this_period = this_period(@chubu_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_rakuten_pay_out_period =  out_period(@chubu_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_rakuten_pay_inc_period =  inc_period(@chubu_rakuten_pay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_rakuten_pay_dec_period =  dec_period(@chubu_rakuten_pay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @chubu_rakuten_pay_def_period =  def_period(@chubu_rakuten_pay_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      # 獲得件数
      @chubu_rakuten_pays_length = cash_length(@chubu_rakuten_pay_this_period,@chubu_rakuten_pay_def_period,@chubu_rakuten_pay_inc_period, @chubu_aupay_dec_period)
    # 評価売
      @chubu_rakuten_pay_valuation = @chubu_rakuten_pay_this_period.sum(:valuation) - @chubu_rakuten_pay_def_period.sum(:valuation) +
      @chubu_rakuten_pay_inc_period.sum(:valuation) - @chubu_rakuten_pay_dec_period.sum(:valuation)
    # 実売
      @chubu_rakuten_pay_profit = @chubu_rakuten_pay_this_period.sum(:profit) - @chubu_rakuten_pay_def_period.sum(:profit) +
      @chubu_rakuten_pay_inc_period.sum(:profit) - @chubu_rakuten_pay_dec_period.sum(:profit)
    # 累計売上
      @chubu_cash_sum_valuation = @chubu_dmer_valuation + @chubu_dmer_slmt_valuation + @chubu_aupay_valuation + @chubu_aupay_slmt_valuation + @chubu_paypay_valuation + @chubu_rakuten_pay_valuation
      @chubu_cash_sum_profit = @chubu_dmer_profit + @chubu_dmer_slmt_profit + @chubu_aupay_profit + @chubu_aupay_slmt_profit +
                              @chubu_paypay_profit +  @chubu_rakuten_pay_profit
    # 先週売上
    # dメル
      @chubu_dmer_users_prev_week = Dmer.includes(:user).where(user: {base: "中部SS"})
      @chubu_dmer_this_period_prev_week = this_period(@chubu_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_dmer_out_period_prev_week =  out_period(@chubu_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_dmer_inc_period_prev_week =  inc_period(@chubu_dmer_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_dmer_dec_period_prev_week =  dec_period(@chubu_dmer_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_dmer_def_period_prev_week =  def_period(@chubu_dmer_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      
      @chubu_dmer_slmt_this_period_prev_week = slmt_this_period(@chubu_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_dmer_slmt_out_period_prev_week = slmt_out_period(@chubu_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_dmer_slmt_inc_period_prev_week = slmt_inc_period(@chubu_dmer_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_dmer_slmt_dec_period_prev_week = slmt_dec_period(@chubu_dmer_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_dmer_slmt_def_period_prev_week = slmt_def_period(@chubu_dmer_slmt_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @chubu_dmer_valuation_prev_week = @chubu_dmer_this_period_prev_week.sum(:valuation_new) - @chubu_dmer_def_period_prev_week.sum(:valuation_new) + @chubu_dmer_inc_period_prev_week.sum(:valuation_new) - @chubu_dmer_dec_period_prev_week.sum(:valuation_new)
      @chubu_dmer_slmt_valuation_prev_week = @chubu_dmer_slmt_this_period_prev_week.sum(:valuation_settlement) -
                                  @chubu_dmer_slmt_def_period_prev_week.sum(:valuation_settlement) +
                                  @chubu_dmer_slmt_inc_period_prev_week.sum(:valuation_settlement) - 
                                  @chubu_dmer_slmt_dec_period_prev_week.sum(:valuation_settlement)
    # 実売
      @chubu_dmer_profit_prev_week = @chubu_dmer_this_period_prev_week.sum(:profit_new) - @chubu_dmer_def_period_prev_week.sum(:profit_new) +
                              @chubu_dmer_inc_period_prev_week.sum(:profit_new) - @chubu_dmer_dec_period_prev_week.sum(:profit_new)
      @chubu_dmer_slmt_profit_prev_week = @chubu_dmer_slmt_this_period_prev_week.sum(:profit_settlement) -
                                  @chubu_dmer_slmt_def_period_prev_week.sum(:profit_settlement) +
                                  @chubu_dmer_slmt_inc_period_prev_week.sum(:profit_settlement) - 
                                  @chubu_dmer_slmt_dec_period_prev_week.sum(:profit_settlement)
    # aupay
      @chubu_aupay_users = Aupay.includes(:user).where(user: {base: "中部SS"})
      @chubu_aupay_this_period_prev_week = this_period(@chubu_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_aupay_out_period_prev_week =  out_period(@chubu_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_aupay_inc_period_prev_week =  inc_period(@chubu_aupay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_aupay_dec_period_prev_week =  dec_period(@chubu_aupay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_aupay_def_period_prev_week =  def_period(@chubu_aupay_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      
      @chubu_aupay_slmt_this_period_prev_week = slmt_this_period(@chubu_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_aupay_slmt_out_period_prev_week = slmt_out_period(@chubu_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_aupay_slmt_inc_period_prev_week = slmt_inc_period(@chubu_aupay_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_aupay_slmt_dec_period_prev_week = slmt_dec_period(@chubu_aupay_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_aupay_slmt_def_period_prev_week = slmt_def_period(@chubu_aupay_slmt_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @chubu_aupay_valuation_prev_week = @chubu_aupay_this_period_prev_week.sum(:valuation_new) - @chubu_aupay_def_period_prev_week.sum(:valuation_new) + @chubu_aupay_inc_period_prev_week.sum(:valuation_new) - @chubu_aupay_dec_period_prev_week.sum(:valuation_new)
      @chubu_aupay_slmt_valuation_prev_week = @chubu_aupay_slmt_this_period_prev_week.sum(:valuation_settlement) -
                                  @chubu_aupay_slmt_def_period_prev_week.sum(:valuation_settlement) +
                                  @chubu_aupay_slmt_inc_period_prev_week.sum(:valuation_settlement) - 
                                  @chubu_aupay_slmt_dec_period_prev_week.sum(:valuation_settlement)
    # 実売
      @chubu_aupay_profit_prev_week = @chubu_aupay_this_period_prev_week.sum(:profit_new) - @chubu_aupay_def_period_prev_week.sum(:profit_new) +
                              @chubu_aupay_inc_period_prev_week.sum(:profit_new) - @chubu_aupay_dec_period_prev_week.sum(:profit_new)
      @chubu_aupay_slmt_profit_prev_week = @chubu_aupay_slmt_this_period_prev_week.sum(:profit_settlement) -
                                  @chubu_aupay_slmt_def_period_prev_week.sum(:profit_settlement) +
                                  @chubu_aupay_slmt_inc_period_prev_week.sum(:profit_settlement) - 
                                  @chubu_aupay_slmt_dec_period_prev_week.sum(:profit_settlement)
    # PayPay
      @chubu_paypay_this_period_prev_week = this_period(@chubu_paypay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_paypay_def_period_prev_week = def_period(@chubu_paypay_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @chubu_paypay_valuation_prev_week = @chubu_paypay_this_period_prev_week.sum(:valuation) - @chubu_paypay_def_period_prev_week.sum(:valuation)
    # 実売
      @chubu_paypay_profit_prev_week = @chubu_paypay_this_period_prev_week.sum(:profit) - @chubu_paypay_def_period_prev_week.sum(:profit)
    # 楽天ペイ
      @chubu_rakuten_pay_this_period_prev_week = this_period(@chubu_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_rakuten_pay_out_period_prev_week =  out_period(@chubu_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_rakuten_pay_inc_period_prev_week =  inc_period(@chubu_rakuten_pay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_rakuten_pay_dec_period_prev_week =  dec_period(@chubu_rakuten_pay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @chubu_rakuten_pay_def_period_prev_week =  def_period(@chubu_rakuten_pay_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @chubu_rakuten_pay_valuation_prev_week = @chubu_rakuten_pay_this_period_prev_week.sum(:valuation) - @chubu_rakuten_pay_def_period_prev_week.sum(:valuation) +
      @chubu_rakuten_pay_inc_period_prev_week.sum(:valuation) - @chubu_rakuten_pay_dec_period_prev_week.sum(:valuation)
    # 実売
      @chubu_rakuten_pay_profit_prev_week = @chubu_rakuten_pay_this_period_prev_week.sum(:profit) - @chubu_rakuten_pay_def_period_prev_week.sum(:profit) +
      @chubu_rakuten_pay_inc_period_prev_week.sum(:profit) - @chubu_rakuten_pay_dec_period_prev_week.sum(:profit)
    # 累計売上
      @chubu_cash_sum_valuation_prev_week = @chubu_dmer_valuation_prev_week + @chubu_dmer_slmt_valuation_prev_week + @chubu_aupay_valuation_prev_week + @chubu_aupay_slmt_valuation_prev_week + @chubu_paypay_valuation_prev_week
      @chubu_cash_sum_profit_prev_week = @chubu_dmer_profit_prev_week + @chubu_dmer_slmt_profit_prev_week + @chubu_aupay_profit_prev_week + @chubu_aupay_slmt_profit_prev_week + @chubu_paypay_profit_prev_week + @chubu_rakuten_pay_profit_prev_week
  # 関東
    # 現状売上
    # dメル
      @kanto_dmer_users = Dmer.includes(:user).where(user: {base: "関東SS"})
      @kanto_dmer_this_period = this_period(@kanto_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_dmer_out_period =  out_period(@kanto_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_dmer_inc_period =  inc_period(@kanto_dmer_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_dmer_dec_period =  dec_period(@kanto_dmer_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_dmer_def_period =  def_period(@kanto_dmer_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      
      @kanto_dmer_slmt_this_period = slmt_this_period(@kanto_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_dmer_slmt_out_period = slmt_out_period(@kanto_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_dmer_slmt_inc_period = slmt_inc_period(@kanto_dmer_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_dmer_slmt_dec_period = slmt_dec_period(@kanto_dmer_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_dmer_slmt_def_period = slmt_def_period(@kanto_dmer_slmt_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      # 獲得件数
      @kanto_dmers_length = cash_length(@kanto_dmer_this_period,@kanto_dmer_def_period,@kanto_dmer_inc_period, @kanto_dmer_dec_period)
      @kanto_dmers_slmt_length = cash_length(@kanto_dmer_slmt_this_period,@kanto_dmer_slmt_def_period,@kanto_dmer_slmt_inc_period, @kanto_dmer_slmt_dec_period)
    # 評価売
      @kanto_dmer_valuation = @kanto_dmer_this_period.sum(:valuation_new) - @kanto_dmer_def_period.sum(:valuation_new) +
                              @kanto_dmer_inc_period.sum(:valuation_new) - @kanto_dmer_dec_period.sum(:valuation_new)
      @kanto_dmer_slmt_valuation = @kanto_dmer_slmt_this_period.sum(:valuation_settlement) -
                                  @kanto_dmer_slmt_def_period.sum(:valuation_settlement) +
                                  @kanto_dmer_slmt_inc_period.sum(:valuation_settlement) - 
                                  @kanto_dmer_slmt_dec_period.sum(:valuation_settlement)
    # 実売
      @kanto_dmer_profit = @kanto_dmer_this_period.sum(:profit_new) - @kanto_dmer_def_period.sum(:profit_new) +
                              @kanto_dmer_inc_period.sum(:profit_new) - @kanto_dmer_dec_period.sum(:profit_new)
      @kanto_dmer_slmt_profit = @kanto_dmer_slmt_this_period.sum(:profit_settlement) -
                                  @kanto_dmer_slmt_def_period.sum(:profit_settlement) +
                                  @kanto_dmer_slmt_inc_period.sum(:profit_settlement) - 
                                  @kanto_dmer_slmt_dec_period.sum(:profit_settlement)
    # aupay
      @kanto_aupay_users = Aupay.includes(:user).where(user: {base: "関東SS"})
      @kanto_aupay_this_period = this_period(@kanto_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_aupay_out_period =  out_period(@kanto_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_aupay_inc_period =  inc_period(@kanto_aupay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_aupay_dec_period =  dec_period(@kanto_aupay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_aupay_def_period =  def_period(@kanto_aupay_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      
      @kanto_aupay_slmt_this_period = slmt_this_period(@kanto_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_aupay_slmt_out_period = slmt_out_period(@kanto_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_aupay_slmt_inc_period = slmt_inc_period(@kanto_aupay_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_aupay_slmt_dec_period = slmt_dec_period(@kanto_aupay_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_aupay_slmt_def_period = slmt_def_period(@kanto_aupay_slmt_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
    # 獲得件数
      @kanto_aupays_length = cash_length(@kanto_aupay_this_period,@kanto_aupay_def_period,@kanto_aupay_inc_period, @kanto_aupay_dec_period)
      @kanto_aupays_slmt_length = cash_length(@kanto_aupay_slmt_this_period,@kanto_aupay_slmt_def_period,@kanto_aupay_slmt_inc_period, @kanto_aupay_slmt_dec_period)
    # 評価売
      @kanto_aupay_valuation = @kanto_aupay_this_period.sum(:valuation_new) - @kanto_aupay_def_period.sum(:valuation_new) +
                              @kanto_aupay_inc_period.sum(:valuation_new) - @kanto_aupay_dec_period.sum(:valuation_new)
      @kanto_aupay_slmt_valuation = @kanto_aupay_slmt_this_period.sum(:valuation_settlement) -
                                  @kanto_aupay_slmt_def_period.sum(:valuation_settlement) +
                                  @kanto_aupay_slmt_inc_period.sum(:valuation_settlement) - 
                                  @kanto_aupay_slmt_dec_period.sum(:valuation_settlement)
    # 実売
      @kanto_aupay_profit = @kanto_aupay_this_period.sum(:profit_new) - @kanto_aupay_def_period.sum(:profit_new) +
                              @kanto_aupay_inc_period.sum(:profit_new) - @kanto_aupay_dec_period.sum(:profit_new)
      @kanto_aupay_slmt_profit = @kanto_aupay_slmt_this_period.sum(:profit_settlement) -
                                  @kanto_aupay_slmt_def_period.sum(:profit_settlement) +
                                  @kanto_aupay_slmt_inc_period.sum(:profit_settlement) - 
                                  @kanto_aupay_slmt_dec_period.sum(:profit_settlement)
    # PayPay
      @kanto_paypay_users = Paypay.includes(:user).where(user: {base: "関東SS"})
      @kanto_paypay_this_period = this_period(@kanto_paypay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_paypay_def_period = def_period(@kanto_paypay_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
    # 獲得数
      @kanto_paypays_length = @kanto_paypay_this_period.length - @kanto_paypay_def_period.length
    # 評価売
      @kanto_paypay_valuation = @kanto_paypay_this_period.sum(:valuation) - @kanto_paypay_def_period.sum(:valuation)
    # 実売
      @kanto_paypay_profit = @kanto_paypay_this_period.sum(:profit) - @kanto_paypay_def_period.sum(:profit)
    # 楽天ペイ
      @kanto_rakuten_pay_users = RakutenPay.includes(:user).where(user: {base: "関東SS"})
      @kanto_rakuten_pay_this_period = this_period(@kanto_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_rakuten_pay_out_period =  out_period(@kanto_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_rakuten_pay_inc_period =  inc_period(@kanto_rakuten_pay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_rakuten_pay_dec_period =  dec_period(@kanto_rakuten_pay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kanto_rakuten_pay_def_period =  def_period(@kanto_rakuten_pay_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
    # 獲得件数
      @kanto_rakuten_pays_length = cash_length(@kanto_rakuten_pay_this_period,@kanto_rakuten_pay_def_period,@kanto_rakuten_pay_inc_period, @kanto_rakuten_pay_dec_period)
    # 評価売
      @kanto_rakuten_pay_valuation = @kanto_rakuten_pay_this_period.sum(:valuation) - @kanto_rakuten_pay_def_period.sum(:valuation) +
      @kanto_rakuten_pay_inc_period.sum(:valuation) - @kanto_rakuten_pay_dec_period.sum(:valuation)
    # 実売
      @kanto_rakuten_pay_profit = @kanto_rakuten_pay_this_period.sum(:profit) - @kanto_rakuten_pay_def_period.sum(:profit) +
      @kanto_rakuten_pay_inc_period.sum(:profit) - @kanto_rakuten_pay_dec_period.sum(:profit)
    # 累計売上
      @kanto_cash_sum_valuation = @kanto_dmer_valuation + @kanto_dmer_slmt_valuation + @kanto_aupay_valuation + @kanto_aupay_slmt_valuation + @kanto_paypay_valuation + @kanto_rakuten_pay_valuation
      @kanto_cash_sum_profit = @kanto_dmer_profit + @kanto_dmer_slmt_profit + @kanto_aupay_profit + @kanto_aupay_slmt_profit +
                              @kanto_paypay_profit +  @kanto_rakuten_pay_profit
    # 先週売上
    # dメル
      @kanto_dmer_users_prev_week = Dmer.includes(:user).where(user: {base: "関東SS"})
      @kanto_dmer_this_period_prev_week = this_period(@kanto_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_dmer_out_period_prev_week =  out_period(@kanto_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_dmer_inc_period_prev_week =  inc_period(@kanto_dmer_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_dmer_dec_period_prev_week =  dec_period(@kanto_dmer_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_dmer_def_period_prev_week =  def_period(@kanto_dmer_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      
      @kanto_dmer_slmt_this_period_prev_week = slmt_this_period(@kanto_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_dmer_slmt_out_period_prev_week = slmt_out_period(@kanto_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_dmer_slmt_inc_period_prev_week = slmt_inc_period(@kanto_dmer_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_dmer_slmt_dec_period_prev_week = slmt_dec_period(@kanto_dmer_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_dmer_slmt_def_period_prev_week = slmt_def_period(@kanto_dmer_slmt_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @kanto_dmer_valuation_prev_week = @kanto_dmer_this_period_prev_week.sum(:valuation_new) - @kanto_dmer_def_period_prev_week.sum(:valuation_new) +
                              @kanto_dmer_inc_period_prev_week.sum(:valuation_new) - @kanto_dmer_dec_period_prev_week.sum(:valuation_new)
      @kanto_dmer_slmt_valuation_prev_week = @kanto_dmer_slmt_this_period_prev_week.sum(:valuation_settlement) -
                                  @kanto_dmer_slmt_def_period_prev_week.sum(:valuation_settlement) +
                                  @kanto_dmer_slmt_inc_period_prev_week.sum(:valuation_settlement) - 
                                  @kanto_dmer_slmt_dec_period_prev_week.sum(:valuation_settlement)
    # 実売
      @kanto_dmer_profit_prev_week = @kanto_dmer_this_period_prev_week.sum(:profit_new) - @kanto_dmer_def_period_prev_week.sum(:profit_new) +
                              @kanto_dmer_inc_period_prev_week.sum(:profit_new) - @kanto_dmer_dec_period_prev_week.sum(:profit_new)
      @kanto_dmer_slmt_profit_prev_week = @kanto_dmer_slmt_this_period_prev_week.sum(:profit_settlement) -
                                  @kanto_dmer_slmt_def_period_prev_week.sum(:profit_settlement) +
                                  @kanto_dmer_slmt_inc_period_prev_week.sum(:profit_settlement) - 
                                  @kanto_dmer_slmt_dec_period_prev_week.sum(:profit_settlement)
    # aupay
      @kanto_aupay_users = Aupay.includes(:user).where(user: {base: "関東SS"})
      @kanto_aupay_this_period_prev_week = this_period(@kanto_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_aupay_out_period_prev_week =  out_period(@kanto_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_aupay_inc_period_prev_week =  inc_period(@kanto_aupay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_aupay_dec_period_prev_week =  dec_period(@kanto_aupay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_aupay_def_period_prev_week =  def_period(@kanto_aupay_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      
      @kanto_aupay_slmt_this_period_prev_week = slmt_this_period(@kanto_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_aupay_slmt_out_period_prev_week = slmt_out_period(@kanto_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_aupay_slmt_inc_period_prev_week = slmt_inc_period(@kanto_aupay_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_aupay_slmt_dec_period_prev_week = slmt_dec_period(@kanto_aupay_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_aupay_slmt_def_period_prev_week = slmt_def_period(@kanto_aupay_slmt_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @kanto_aupay_valuation_prev_week = @kanto_aupay_this_period_prev_week.sum(:valuation_new) - @kanto_aupay_def_period_prev_week.sum(:valuation_new) +
                              @kanto_aupay_inc_period_prev_week.sum(:valuation_new) - @kanto_aupay_dec_period_prev_week.sum(:valuation_new)
      @kanto_aupay_slmt_valuation_prev_week = @kanto_aupay_slmt_this_period_prev_week.sum(:valuation_settlement) -
                                  @kanto_aupay_slmt_def_period_prev_week.sum(:valuation_settlement) +
                                  @kanto_aupay_slmt_inc_period_prev_week.sum(:valuation_settlement) - 
                                  @kanto_aupay_slmt_dec_period_prev_week.sum(:valuation_settlement)
    # 実売
      @kanto_aupay_profit_prev_week = @kanto_aupay_this_period_prev_week.sum(:profit_new) - @kanto_aupay_def_period_prev_week.sum(:profit_new) +
                              @kanto_aupay_inc_period_prev_week.sum(:profit_new) - @kanto_aupay_dec_period_prev_week.sum(:profit_new)
      @kanto_aupay_slmt_profit_prev_week = @kanto_aupay_slmt_this_period_prev_week.sum(:profit_settlement) -
                                  @kanto_aupay_slmt_def_period_prev_week.sum(:profit_settlement) +
                                  @kanto_aupay_slmt_inc_period_prev_week.sum(:profit_settlement) - 
                                  @kanto_aupay_slmt_dec_period_prev_week.sum(:profit_settlement)
    # PayPay
      @kanto_paypay_this_period_prev_week = this_period(@kanto_paypay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_paypay_def_period_prev_week = def_period(@kanto_paypay_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @kanto_paypay_valuation_prev_week = @kanto_paypay_this_period_prev_week.sum(:valuation) - @kanto_paypay_def_period_prev_week.sum(:valuation)
    # 実売
      @kanto_paypay_profit_prev_week = @kanto_paypay_this_period_prev_week.sum(:profit) - @kanto_paypay_def_period_prev_week.sum(:profit)
    # 楽天ペイ
      @kanto_rakuten_pay_this_period_prev_week = this_period(@kanto_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_rakuten_pay_out_period_prev_week =  out_period(@kanto_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_rakuten_pay_inc_period_prev_week =  inc_period(@kanto_rakuten_pay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_rakuten_pay_dec_period_prev_week =  dec_period(@kanto_rakuten_pay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kanto_rakuten_pay_def_period_prev_week =  def_period(@kanto_rakuten_pay_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @kanto_rakuten_pay_valuation_prev_week = @kanto_rakuten_pay_this_period_prev_week.sum(:valuation) - @kanto_rakuten_pay_def_period_prev_week.sum(:valuation) +
      @kanto_rakuten_pay_inc_period_prev_week.sum(:valuation) - @kanto_rakuten_pay_dec_period_prev_week.sum(:valuation)
    # 実売
      @kanto_rakuten_pay_profit_prev_week = @kanto_rakuten_pay_this_period_prev_week.sum(:profit) - @kanto_rakuten_pay_def_period_prev_week.sum(:profit) +
      @kanto_rakuten_pay_inc_period_prev_week.sum(:profit) - @kanto_rakuten_pay_dec_period_prev_week.sum(:profit)
    # 累計売上
      @kanto_cash_sum_valuation_prev_week = @kanto_dmer_valuation_prev_week + @kanto_dmer_slmt_valuation_prev_week + @kanto_aupay_valuation_prev_week + @kanto_aupay_slmt_valuation_prev_week + @kanto_paypay_valuation_prev_week
      @kanto_cash_sum_profit_prev_week = @kanto_dmer_profit_prev_week + @kanto_dmer_slmt_profit_prev_week + @kanto_aupay_profit_prev_week + @kanto_aupay_slmt_profit_prev_week + @kanto_paypay_profit_prev_week + @kanto_rakuten_pay_profit_prev_week
  # 関西
    # dメル
      @kansai_dmer_users = Dmer.includes(:user).where(user: {base: "関西SS"})
      @kansai_dmer_this_period = this_period(@kansai_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_dmer_out_period =  out_period(@kansai_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_dmer_inc_period =  inc_period(@kansai_dmer_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_dmer_dec_period =  dec_period(@kansai_dmer_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_dmer_def_period =  def_period(@kansai_dmer_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      
      @kansai_dmer_slmt_this_period = slmt_this_period(@kansai_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_dmer_slmt_out_period = slmt_out_period(@kansai_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_dmer_slmt_inc_period = slmt_inc_period(@kansai_dmer_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_dmer_slmt_dec_period = slmt_dec_period(@kansai_dmer_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_dmer_slmt_def_period = slmt_def_period(@kansai_dmer_slmt_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
    # 獲得件数
      @kansai_dmers_length = cash_length(@kansai_dmer_this_period,@kansai_dmer_def_period,@kansai_dmer_inc_period, @kansai_dmer_dec_period)
      @kansai_dmers_slmt_length = cash_length(@kansai_dmer_slmt_this_period,@kansai_dmer_slmt_def_period,@kansai_dmer_slmt_inc_period, @kansai_dmer_slmt_dec_period)
    # 評価売
      @kansai_dmer_valuation = @kansai_dmer_this_period.sum(:valuation_new) - @kansai_dmer_def_period.sum(:valuation_new) +
                              @kansai_dmer_inc_period.sum(:valuation_new) - @kansai_dmer_dec_period.sum(:valuation_new)
      @kansai_dmer_slmt_valuation = @kansai_dmer_slmt_this_period.sum(:valuation_settlement) -
                                  @kansai_dmer_slmt_def_period.sum(:valuation_settlement) +
                                  @kansai_dmer_slmt_inc_period.sum(:valuation_settlement) - 
                                  @kansai_dmer_slmt_dec_period.sum(:valuation_settlement)
    # 実売
      @kansai_dmer_profit = @kansai_dmer_this_period.sum(:profit_new) - @kansai_dmer_def_period.sum(:profit_new) +
                              @kansai_dmer_inc_period.sum(:profit_new) - @kansai_dmer_dec_period.sum(:profit_new)
      @kansai_dmer_slmt_profit = @kansai_dmer_slmt_this_period.sum(:profit_settlement) -
                                  @kansai_dmer_slmt_def_period.sum(:profit_settlement) +
                                  @kansai_dmer_slmt_inc_period.sum(:profit_settlement) - 
                                  @kansai_dmer_slmt_dec_period.sum(:profit_settlement)
    # aupay
      @kansai_aupay_users = Aupay.includes(:user).where(user: {base: "関西SS"})
      @kansai_aupay_this_period = this_period(@kansai_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_aupay_out_period =  out_period(@kansai_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_aupay_inc_period =  inc_period(@kansai_aupay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_aupay_dec_period =  dec_period(@kansai_aupay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_aupay_def_period =  def_period(@kansai_aupay_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      
      @kansai_aupay_slmt_this_period = slmt_this_period(@kansai_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_aupay_slmt_out_period = slmt_out_period(@kansai_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_aupay_slmt_inc_period = slmt_inc_period(@kansai_aupay_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_aupay_slmt_dec_period = slmt_dec_period(@kansai_aupay_slmt_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_aupay_slmt_def_period = slmt_def_period(@kansai_aupay_slmt_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
    # 獲得件数
      @kansai_aupays_length = cash_length(@kansai_aupay_this_period,@kansai_aupay_def_period,@kansai_aupay_inc_period, @kansai_aupay_dec_period)
      @kansai_aupays_slmt_length = cash_length(@kansai_aupay_slmt_this_period,@kansai_aupay_slmt_def_period,@kansai_aupay_slmt_inc_period, @kansai_aupay_slmt_dec_period)
    # 評価売
      @kansai_aupay_valuation = @kansai_aupay_this_period.sum(:valuation_new) - @kansai_aupay_def_period.sum(:valuation_new) +
                              @kansai_aupay_inc_period.sum(:valuation_new) - @kansai_aupay_dec_period.sum(:valuation_new)
      @kansai_aupay_slmt_valuation = @kansai_aupay_slmt_this_period.sum(:valuation_settlement) -
                                  @kansai_aupay_slmt_def_period.sum(:valuation_settlement) +
                                  @kansai_aupay_slmt_inc_period.sum(:valuation_settlement) - 
                                  @kansai_aupay_slmt_dec_period.sum(:valuation_settlement)
    # 実売
      @kansai_aupay_profit = @kansai_aupay_this_period.sum(:profit_new) - @kansai_aupay_def_period.sum(:profit_new) +
                              @kansai_aupay_inc_period.sum(:profit_new) - @kansai_aupay_dec_period.sum(:profit_new)
      @kansai_aupay_slmt_profit = @kansai_aupay_slmt_this_period.sum(:profit_settlement) -
                                  @kansai_aupay_slmt_def_period.sum(:profit_settlement) +
                                  @kansai_aupay_slmt_inc_period.sum(:profit_settlement) - 
                                  @kansai_aupay_slmt_dec_period.sum(:profit_settlement)
    # PayPay
      @kansai_paypay_users = Paypay.includes(:user).where(user: {base: "関西SS"})
      @kansai_paypay_this_period = this_period(@kansai_paypay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_paypay_def_period = def_period(@kansai_paypay_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
    # 獲得数
      @kansai_paypays_length = @kansai_paypay_this_period.length - @kansai_paypay_def_period.length
    # 評価売
      @kansai_paypay_valuation = @kansai_paypay_this_period.sum(:valuation) - @kansai_paypay_def_period.sum(:valuation)
    # 実売
      @kansai_paypay_profit = @kansai_paypay_this_period.sum(:profit) - @kansai_paypay_def_period.sum(:profit)
    # 楽天ペイ
      @kansai_rakuten_pay_users = RakutenPay.includes(:user).where(user: {base: "関東SS"})
      @kansai_rakuten_pay_this_period = this_period(@kansai_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_rakuten_pay_out_period =  out_period(@kansai_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_rakuten_pay_inc_period =  inc_period(@kansai_rakuten_pay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_rakuten_pay_dec_period =  dec_period(@kansai_rakuten_pay_out_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
      @kansai_rakuten_pay_def_period =  def_period(@kansai_rakuten_pay_this_period,@display_period_1.start_period_01,@display_period_1.end_period_01)
    # 獲得件数
      @kansai_rakuten_pays_length = cash_length(@kansai_rakuten_pay_this_period,@kansai_rakuten_pay_def_period,@kansai_rakuten_pay_inc_period, @kansai_rakuten_pay_dec_period)
    # 評価売
      @kansai_rakuten_pay_valuation = @kansai_rakuten_pay_this_period.sum(:valuation) - @kansai_rakuten_pay_def_period.sum(:valuation) +
      @kansai_rakuten_pay_inc_period.sum(:valuation) - @kansai_rakuten_pay_dec_period.sum(:valuation)
    # 実売
      @kansai_rakuten_pay_profit = @kansai_rakuten_pay_this_period.sum(:profit) - @kansai_rakuten_pay_def_period.sum(:profit) +
      @kansai_rakuten_pay_inc_period.sum(:profit) - @kansai_rakuten_pay_dec_period.sum(:profit)
  # 累計売上
      @kansai_cash_sum_valuation = @kansai_dmer_valuation + @kansai_dmer_slmt_valuation + @kansai_aupay_valuation + @kansai_aupay_slmt_valuation + @kansai_paypay_valuation + @kansai_rakuten_pay_valuation
      @kansai_cash_sum_profit = @kansai_dmer_profit + @kansai_dmer_slmt_profit + @kansai_aupay_profit + @kansai_aupay_slmt_profit +
                              @kansai_paypay_profit +  @kansai_rakuten_pay_profit
  # 先週売上
    # dメル
      @kansai_dmer_users_prev_week = Dmer.includes(:user).where(user: {base: "関西SS"})
      @kansai_dmer_this_period_prev_week = this_period(@kansai_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_dmer_out_period_prev_week =  out_period(@kansai_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_dmer_inc_period_prev_week =  inc_period(@kansai_dmer_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_dmer_dec_period_prev_week =  dec_period(@kansai_dmer_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_dmer_def_period_prev_week =  def_period(@kansai_dmer_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      
      @kansai_dmer_slmt_this_period_prev_week = slmt_this_period(@kansai_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_dmer_slmt_out_period_prev_week = slmt_out_period(@kansai_dmer_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_dmer_slmt_inc_period_prev_week = slmt_inc_period(@kansai_dmer_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_dmer_slmt_dec_period_prev_week = slmt_dec_period(@kansai_dmer_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_dmer_slmt_def_period_prev_week = slmt_def_period(@kansai_dmer_slmt_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @kansai_dmer_valuation_prev_week = @kansai_dmer_this_period_prev_week.sum(:valuation_new) - @kansai_dmer_def_period_prev_week.sum(:valuation_new) +
                              @kansai_dmer_inc_period_prev_week.sum(:valuation_new) - @kansai_dmer_dec_period_prev_week.sum(:valuation_new)
      @kansai_dmer_slmt_valuation_prev_week = @kansai_dmer_slmt_this_period_prev_week.sum(:valuation_settlement) -
                                  @kansai_dmer_slmt_def_period_prev_week.sum(:valuation_settlement) +
                                  @kansai_dmer_slmt_inc_period_prev_week.sum(:valuation_settlement) - 
                                  @kansai_dmer_slmt_dec_period_prev_week.sum(:valuation_settlement)
    # 実売
      @kansai_dmer_profit_prev_week = @kansai_dmer_this_period_prev_week.sum(:profit_new) - @kansai_dmer_def_period_prev_week.sum(:profit_new) +
                              @kansai_dmer_inc_period_prev_week.sum(:profit_new) - @kansai_dmer_dec_period_prev_week.sum(:profit_new)
      @kansai_dmer_slmt_profit_prev_week = @kansai_dmer_slmt_this_period_prev_week.sum(:profit_settlement) -
                                  @kansai_dmer_slmt_def_period_prev_week.sum(:profit_settlement) +
                                  @kansai_dmer_slmt_inc_period_prev_week.sum(:profit_settlement) - 
                                  @kansai_dmer_slmt_dec_period_prev_week.sum(:profit_settlement)
    # aupay
      @kansai_aupay_users = Aupay.includes(:user).where(user: {base: "関東SS"})
      @kansai_aupay_this_period_prev_week = this_period(@kansai_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_aupay_out_period_prev_week =  out_period(@kansai_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_aupay_inc_period_prev_week =  inc_period(@kansai_aupay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_aupay_dec_period_prev_week =  dec_period(@kansai_aupay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_aupay_def_period_prev_week =  def_period(@kansai_aupay_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      
      @kansai_aupay_slmt_this_period_prev_week = slmt_this_period(@kansai_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_aupay_slmt_out_period_prev_week = slmt_out_period(@kansai_aupay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_aupay_slmt_inc_period_prev_week = slmt_inc_period(@kansai_aupay_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_aupay_slmt_dec_period_prev_week = slmt_dec_period(@kansai_aupay_slmt_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_aupay_slmt_def_period_prev_week = slmt_def_period(@kansai_aupay_slmt_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @kansai_aupay_valuation_prev_week = @kansai_aupay_this_period_prev_week.sum(:valuation_new) - @kansai_aupay_def_period_prev_week.sum(:valuation_new) +
                            @kansai_aupay_inc_period_prev_week.sum(:valuation_new) - @kansai_aupay_dec_period_prev_week.sum(:valuation_new)
      @kansai_aupay_slmt_valuation_prev_week = @kansai_aupay_slmt_this_period_prev_week.sum(:valuation_settlement) -
                                 @kansai_aupay_slmt_def_period_prev_week.sum(:valuation_settlement) +
                                 @kansai_aupay_slmt_inc_period_prev_week.sum(:valuation_settlement) - 
                                 @kansai_aupay_slmt_dec_period_prev_week.sum(:valuation_settlement)
    # 実売
      @kansai_aupay_profit_prev_week = @kansai_aupay_this_period_prev_week.sum(:profit_new) - @kansai_aupay_def_period_prev_week.sum(:profit_new) +
                            @kansai_aupay_inc_period_prev_week.sum(:profit_new) - @kansai_aupay_dec_period_prev_week.sum(:profit_new)
      @kansai_aupay_slmt_profit_prev_week = @kansai_aupay_slmt_this_period_prev_week.sum(:profit_settlement) -
                                 @kansai_aupay_slmt_def_period_prev_week.sum(:profit_settlement) +
                                 @kansai_aupay_slmt_inc_period_prev_week.sum(:profit_settlement) - 
                                 @kansai_aupay_slmt_dec_period_prev_week.sum(:profit_settlement)
    # PayPay
      @kansai_paypay_this_period_prev_week = this_period(@kansai_paypay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_paypay_def_period_prev_week = def_period(@kansai_paypay_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @kansai_paypay_valuation_prev_week = @kansai_paypay_this_period_prev_week.sum(:valuation) - @kansai_paypay_def_period_prev_week.sum(:valuation)
    # 実売
      @kansai_paypay_profit_prev_week = @kansai_paypay_this_period_prev_week.sum(:profit) - @kansai_paypay_def_period_prev_week.sum(:profit)
    # 楽天ペイ
      @kansai_rakuten_pay_this_period_prev_week = this_period(@kansai_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_rakuten_pay_out_period_prev_week =  out_period(@kansai_rakuten_pay_users,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_rakuten_pay_inc_period_prev_week =  inc_period(@kansai_rakuten_pay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_rakuten_pay_dec_period_prev_week =  dec_period(@kansai_rakuten_pay_out_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
      @kansai_rakuten_pay_def_period_prev_week =  def_period(@kansai_rakuten_pay_this_period_prev_week,@display_period_1.start_period_01,@display_period_1.end_period_01.ago(7.days))
    # 評価売
      @kansai_rakuten_pay_valuation_prev_week = @kansai_rakuten_pay_this_period_prev_week.sum(:valuation) - @kansai_rakuten_pay_def_period_prev_week.sum(:valuation) +
      @kansai_rakuten_pay_inc_period_prev_week.sum(:valuation) - @kansai_rakuten_pay_dec_period_prev_week.sum(:valuation)
    # 実売
      @kansai_rakuten_pay_profit_prev_week = @kansai_rakuten_pay_this_period_prev_week.sum(:profit) - @kansai_rakuten_pay_def_period_prev_week.sum(:profit) +
      @kansai_rakuten_pay_inc_period_prev_week.sum(:profit) - @kansai_rakuten_pay_dec_period_prev_week.sum(:profit)
    # 累計売上
      @kansai_cash_sum_valuation_prev_week = @kansai_dmer_valuation_prev_week + @kansai_dmer_slmt_valuation_prev_week + @kansai_aupay_valuation_prev_week + @kansai_aupay_slmt_valuation_prev_week + @kansai_paypay_valuation_prev_week
      @kansai_cash_sum_profit_prev_week = @kansai_dmer_profit_prev_week + @kansai_dmer_slmt_profit_prev_week + @kansai_aupay_profit_prev_week + @kansai_aupay_slmt_profit_prev_week + @kansai_paypay_profit_prev_week + @kansai_rakuten_pay_profit_prev_week
    end

  end 
  
  def create 
    @display_period = DisplayPeriod.new(display_periods_params)
    if @display_period.save
      flash[:notice] = "申請をしました。"
      redirect_to display_periods_path
    else  
      flash[:notice] = "失敗しました。"
      render :index 
    end 
  end 

  def update 
    @display_period_1 = DisplayPeriod.first
    @display_period_1.update(display_periods_params)
    flash[:notice] = "更新しました。"
    redirect_to display_periods_path
  end 

  private
  # dメル,aupayメソッド
    # 新規
    def this_period(product,start_date,end_date)
      return product.where(date: start_date..end_date)
    end

    def out_period(product,start_date,end_date)
      return product.where.not(date: start_date..end_date)
    end
    def inc_period(product,start_date,end_date)
      return product.where(deficiency_solution: start_date..end_date)
    end
    def dec_period(product,start_date,end_date)
      return product.where(deficiency: start_date..end_date)
    end
    def def_period(product,start_date,end_date)
      return product.where.not(deficiency: nil).where(deficiency_solution: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution: start_date..end_date))
    end
    # 決済
    def slmt_this_period(product,start_date,end_date)
      return product.where(settlement: start_date..end_date)
    end
    def slmt_out_period(product,start_date,end_date)
      return product.where.not(settlement: start_date..end_date)
    end
    def slmt_inc_period(product,start_date,end_date)
      return product.where(deficiency_solution_settlement: start_date..end_date)
    end
    def slmt_dec_period(product,start_date,end_date)
      return product.where(deficiency_settlement: start_date..end_date)
    end
    def slmt_def_period(product,start_date,end_date)
      return product.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(product.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: start_date..end_date))
    end

  def cash_length(product,def_product,inc_product, dec_product)
    return product.length -  def_product.length + inc_product.length - dec_product.length
  end 

  def display_periods_params
    params.require(:display_period).permit(
      :start_period_01       ,
      :end_period_01         ,
      :start_period_02       ,
      :end_period_02         ,
      :start_period_03       ,
      :end_period_03         ,
      :start_period_04       ,
      :end_period_04         ,
      :start_period_05       ,
      :end_period_05         
    )
  end 
end
