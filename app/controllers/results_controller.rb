class ResultsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @q = Result.ransack(params[:q])
    @results = 
    if params[:q].nil? 
      Result.none 
    else    
      @q.result(distinct: false).includes(:user).order(date: :asc)
    end
      @shifts = Shift.includes(:user).all
      # 個別利益表 
      if @results.group(:user_id).length == 1 
        # dメル　新規
          @dmers_user = Dmer.where(user_id: @results.first.user_id )
          @dmers_this_month = this_period(@dmers_user,@results)
          @dmers_not_this_month = not_period(@dmers_user,@results)
          @dmers_def_this_month = def_period(@dmers_this_month,@results)
          @dmers_inc = inc_period(@dmers_not_this_month,@results)
          @dmers_dec = dec_period(@dmers_not_this_month,@results)
        # dメル　決済
          @dmers_slmt_this_month = slmt_this_period(@dmers_user,@results)
          @dmers_slmt_not_this_month = slmt_not_period(@dmers_user,@results)
          @dmers_slmt_def_this_month = slmt_def_period(@dmers_this_month,@results)
          @dmers_slmt_inc = slmt_inc_period(@dmers_not_this_month,@results)
          @dmers_slmt_dec = slmt_dec_period(@dmers_not_this_month,@results)
        # aupay　新規
          @aupays_user = Aupay.where(user_id: @results.first.user_id )
          @aupays_this_month = this_period(@aupays_user,@results)
          @aupays_not_this_month = not_period(@aupays_user,@results)
          @aupays_def_this_month = def_period(@aupays_this_month,@results)
          @aupays_inc = inc_period(@aupays_not_this_month,@results)
          @aupays_dec = dec_period(@aupays_not_this_month,@results)
          # aupay　決済
          @aupays_slmt_this_month = slmt_this_period(@aupays_user,@results)
          @aupays_slmt_not_this_month = slmt_not_period(@aupays_user,@results)
          @aupays_slmt_def_this_month = slmt_def_period(@aupays_this_month,@results)
          @aupays_slmt_inc = slmt_inc_period(@aupays_not_this_month,@results)
          @aupays_slmt_dec = slmt_dec_period(@aupays_not_this_month,@results)
        # paypay
            @paypays_user = Paypay.where(user_id: @results.first.user_id )
            @paypays_this_month = this_period(@paypays_user,@results)
            @paypays_def_this_month = def_period(@paypays_this_month,@results)
        # 少額短期保険
          @st_insurances_user = StInsurance.where(user_id: @results.first.user_id )
          @st_insurances_this_month = this_period(@st_insurances_user,@results)
          @st_insurances_def_this_month = def_period(@st_insurances_this_month,@results)
        # 楽天ペイ
          @rakuten_pays_user = RakutenPay.where(user_id: @results.first.user_id )
          @rakuten_pays_this_month = this_period(@rakuten_pays_user,@results)
          @rakuten_pays_not_this_month = not_period(@rakuten_pays_user,@results)
          @rakuten_pays_inc = inc_period(@rakuten_pays_not_this_month,@results)
          @rakuten_pays_dec = dec_period(@rakuten_pays_not_this_month,@results)
          @rakuten_pays_def_this_month = def_period(@rakuten_pays_this_month,@results)
        # 楽天フェムト新規
          @rakuten_casas_user = RakutenCasa.where(user_id: @results.first.user_id)
          @rakuten_casas_this_month = this_period(@rakuten_casas_user, @results)
          @rakuten_casas_not_this_month = not_period(@rakuten_casas_user, @results)
          @rakuten_casas_inc = inc_period(@rakuten_casas_not_this_month, @results)
          @rakuten_casas_dec = dec_period(@rakuten_casas_not_this_month, @results)

          @rakuten_casas_def_this_month = @rakuten_casas_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@rakuten_casas_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))).or(@rakuten_casas_this_month.where.not(deficiency_net: nil).where(deficiency_solution_net: nil)).or(@rakuten_casas_this_month.where.not(deficiency_net: nil).where.not(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date))).or(@rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil)).or(@rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date)))
        # 楽天フェムト設置
          @rakuten_casas_put = @rakuten_casas_user.where(put: @results.minimum(:date)..@results.maximum(:date))
          # 設置
          @rakuten_casas_put_self = @rakuten_casas_put.where(putter_id: @results.first.user_id).where(user_id: @results.first.user_id)
          # 他者設置
          @rakuten_casas_put_other = RakutenCasa.where.not(user_id: @results.first.user_id).where(putter_id: @results.first.user_id).where(put: @results.minimum(:date)..@results.maximum(:date))
          # 設置依頼
          @rakuten_casas_put_request = @rakuten_casas_put.where(user_id: @results.first.user_id).where.not(putter_id: @results.first.user_id)
      elsif @results.joins(:user).preload(:user).group(:base).length >= 2
        # 訪問員数
          @chubu_cash_persons = @results.group(:user_id).where(user: {base: "中部SS",base_sub: "キャッシュレス"})
          @chubu_femto_persons = @results.group(:user_id).where(user: {base: "中部SS",base_sub: "フェムト"})
          @kanto_cash_persons = @results.group(:user_id).where(user: {base: "関東SS",base_sub: "キャッシュレス"})
          @kanto_femto_persons = @results.group(:user_id).where(user: {base: "関東SS",base_sub: "フェムト"})
          @kansai_cash_persons = @results.group(:user_id).where(user: {base: "関西SS",base_sub: "キャッシュレス"})
          @kansai_femto_persons = @results.group(:user_id).where(user: {base: "関西SS",base_sub: "フェムト"})
        # 売上
        # 中部
          # dメル新規
            @chubu_dmer_users = Dmer.includes(:user).where(user: {base: "中部SS"})
            # 今月
            @chubu_dmers_this_month = @chubu_dmer_users.where(date: @results.minimum(:date)..@results.maximum(:date))
            @dmers_test = cash_period(@chubu_dmer_users, @results)
            @chubu_dmers_not_this_month = @chubu_dmer_users.where.not(date: @results.minimum(:date)..@results.maximum(:date))
            @chubu_dmers_inc = @chubu_dmers_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
            @chubu_dmers_dec = @chubu_dmers_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
            @chubu_dmers_def_this_month = @chubu_dmers_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@chubu_dmers_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
            @chubu_dmers_no_def_this_month = @chubu_dmers_this_month.where(deficiency: nil).or(@chubu_dmers_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))

            @chubu_dmers_new_valuation = @chubu_dmers_this_month.sum(:valuation_new) - @chubu_dmers_def_this_month.sum(:valuation_new) + @chubu_dmers_inc.sum(:valuation_new) - @chubu_dmers_dec.sum(:valuation_new)
            @chubu_dmers_new_profit = @chubu_dmers_this_month.sum(:profit_new) - @chubu_dmers_def_this_month.sum(:profit_new) + @chubu_dmers_inc.sum(:valuation_new) - @chubu_dmers_dec.sum(:profit_new)
            # 前週
            @chubu_dmers_last_week = @chubu_dmer_users.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_dmers_not_last_week = @chubu_dmer_users.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_dmers_inc_last_week = @chubu_dmers_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_dmers_dec_last_week = @chubu_dmers_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_dmers_def_last_week = @chubu_dmers_last_week.where.not(deficiency: nil).where(deficiency_solution: nil).or(@chubu_dmers_last_week.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
            @chubu_dmers_no_def_last_week = @chubu_dmers_last_week.where(deficiency: nil).or(@chubu_dmers_last_week.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

            @chubu_dmers_new_valuation_last_week = @chubu_dmers_last_week.sum(:valuation_new) - @chubu_dmers_def_last_week.sum(:valuation_new) + @chubu_dmers_inc_last_week.sum(:valuation_new) - @chubu_dmers_dec_last_week.sum(:valuation_new)
            @chubu_dmers_new_profit_last_week = @chubu_dmers_last_week.sum(:profit_new) - @chubu_dmers_def_last_week.sum(:profit_new) + @chubu_dmers_inc_last_week.sum(:profit_new) - @chubu_dmers_dec_last_week.sum(:profit_new)
          # dメル決済
            # 今月
            @chubu_dmers_slmt_this_month = @chubu_dmer_users.where(settlement: @results.minimum(:date)..@results.maximum(:date))
            @chubu_dmers_slmt_not_this_month = @chubu_dmer_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date))
            @chubu_dmers_slmt_inc = @chubu_dmers_slmt_not_this_month.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date))
            @chubu_dmers_slmt_dec = @chubu_dmers_slmt_not_this_month.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date))
            @chubu_dmers_slmt_def_this_month = @chubu_dmers_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@chubu_dmers_slmt_this_month.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
            @chubu_dmers_slmt_no_def_this_month = @chubu_dmers_slmt_this_month.where(deficiency_settlement: nil).or(@chubu_dmers_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))

            @chubu_dmers_slmt_valuation = @chubu_dmers_slmt_this_month.sum(:valuation_settlement) - @chubu_dmers_slmt_def_this_month.sum(:valuation_settlement) + @chubu_dmers_slmt_inc.sum(:valuation_settlement) - @chubu_dmers_slmt_dec.sum(:valuation_settlement)
            @chubu_dmers_slmt_profit = @chubu_dmers_slmt_this_month.sum(:profit_settlement) - @chubu_dmers_slmt_def_this_month.sum(:profit_settlement) + @chubu_dmers_slmt_inc.sum(:profit_settlement) - @chubu_dmers_slmt_dec.sum(:profit_settlement)
            # 前週
            @chubu_dmers_slmt_last_week = @chubu_dmer_users.where(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_dmers_slmt_not_last_week = @chubu_dmer_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_dmers_slmt_inc_last_week = @chubu_dmers_slmt_not_last_week.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_dmers_slmt_dec_last_week = @chubu_dmers_slmt_not_last_week.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_dmers_slmt_def_last_week = @chubu_dmers_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@chubu_dmers_slmt_last_week.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
            @chubu_dmers_slmt_no_def_last_week = @chubu_dmers_slmt_last_week.where(deficiency_settlement: nil).or(@chubu_dmers_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

            @chubu_dmers_slmt_valuation_last_week = @chubu_dmers_slmt_last_week.sum(:valuation_settlement) - @chubu_dmers_slmt_def_last_week.sum(:valuation_settlement) + @chubu_dmers_slmt_inc_last_week.sum(:valuation_settlement) - @chubu_dmers_slmt_dec_last_week.sum(:valuation_settlement)
            @chubu_dmers_slmt_profit_last_week = @chubu_dmers_slmt_last_week.sum(:profit_settlement) - @chubu_dmers_slmt_def_last_week.sum(:profit_settlement) + @chubu_dmers_slmt_inc_last_week.sum(:profit_settlement) - @chubu_dmers_slmt_dec_last_week.sum(:profit_settlement)
          # aupay新規
            # 今月
            @chubu_aupay_users = Aupay.includes(:user).where(user: {base: "中部SS"})
            @chubu_aupays_this_month = @chubu_aupay_users.where(date: @results.minimum(:date)..@results.maximum(:date))
            @chubu_aupays_not_this_month = @chubu_aupay_users.where.not(date: @results.minimum(:date)..@results.maximum(:date))
            @chubu_aupays_inc = @chubu_aupays_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
            @chubu_aupays_dec = @chubu_aupays_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
            @chubu_aupays_def_this_month = @chubu_aupays_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@chubu_aupays_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
            @chubu_aupays_no_def_this_month = @chubu_aupays_this_month.where(deficiency: nil).or(@chubu_aupays_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))

            @chubu_aupays_new_valuation = @chubu_aupays_this_month.sum(:valuation_new) - @chubu_aupays_def_this_month.sum(:valuation_new) + @chubu_aupays_inc.sum(:valuation_new) - @chubu_aupays_dec.sum(:valuation_new)
            @chubu_aupay_new_profit = @chubu_aupays_this_month.sum(:profit_new) - @chubu_aupays_def_this_month.sum(:profit_new) + @chubu_aupays_inc.sum(:valuation_new) - @chubu_aupays_dec.sum(:profit_new)
            # 前週
            @chubu_aupays_last_week = @chubu_aupay_users.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_aupays_not_last_week = @chubu_aupay_users.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_aupays_inc_last_week = @chubu_aupays_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_aupays_dec_last_week = @chubu_aupays_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_aupays_def_last_week = @chubu_aupays_last_week.where.not(deficiency: nil).where(deficiency_solution: nil).or(@chubu_aupays_last_week.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
            @chubu_aupays_no_def_last_week = @chubu_aupays_last_week.where(deficiency: nil).or(@chubu_aupays_last_week.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

            @chubu_aupay_new_valuation_last_week = @chubu_aupays_last_week.sum(:valuation_new) - @chubu_aupays_def_last_week.sum(:valuation_new) + @chubu_aupays_inc_last_week.sum(:valuation_new) - @chubu_aupays_dec_last_week.sum(:valuation_new)
            @chubu_aupay_new_profit_last_week = @chubu_aupays_last_week.sum(:profit_new) - @chubu_aupays_def_last_week.sum(:profit_new) + @chubu_aupays_inc_last_week.sum(:profit_new) - @chubu_aupays_dec_last_week.sum(:profit_new)
          # aupay決済
            # 今月
            @chubu_aupays_slmt_this_month = @chubu_aupay_users.where(settlement: @results.minimum(:date)..@results.maximum(:date))
            @chubu_aupays_slmt_not_this_month = @chubu_aupay_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date))
            @chubu_aupays_slmt_inc = @chubu_aupays_slmt_not_this_month.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date))
            @chubu_aupays_slmt_dec = @chubu_aupays_slmt_not_this_month.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date))
            @chubu_aupays_slmt_def_this_month = @chubu_aupays_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@chubu_aupays_slmt_this_month.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
            @chubu_aupays_slmt_no_def_this_month = @chubu_aupays_slmt_this_month.where(deficiency_settlement: nil).or(@chubu_aupays_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))

            @chubu_aupays_slmt_valuation = @chubu_aupays_slmt_this_month.sum(:valuation_settlement) - @chubu_aupays_slmt_def_this_month.sum(:valuation_settlement) + @chubu_aupays_slmt_inc.sum(:valuation_settlement) - @chubu_aupays_slmt_dec.sum(:valuation_settlement)
            @chubu_aupays_slmt_profit = @chubu_aupays_slmt_this_month.sum(:profit_settlement) - @chubu_aupays_slmt_def_this_month.sum(:profit_settlement) + @chubu_aupays_slmt_inc.sum(:profit_settlement) - @chubu_aupays_slmt_dec.sum(:profit_settlement)
            # 前週
            @chubu_aupays_slmt_last_week = @chubu_aupay_users.where(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_aupays_slmt_not_last_week = @chubu_aupay_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_aupays_slmt_inc_last_week = @chubu_aupays_slmt_not_last_week.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_aupays_slmt_dec_last_week = @chubu_aupays_slmt_not_last_week.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_aupays_slmt_def_last_week = @chubu_aupays_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@chubu_aupays_slmt_last_week.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
            @chubu_aupays_slmt_no_def_last_week = @chubu_aupays_slmt_last_week.where(deficiency_settlement: nil).or(@chubu_aupays_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

            @chubu_aupays_slmt_valuation_last_week = @chubu_aupays_slmt_last_week.sum(:valuation_settlement) - @chubu_aupays_slmt_def_last_week.sum(:valuation_settlement) + @chubu_aupays_slmt_inc_last_week.sum(:valuation_settlement) - @chubu_aupays_slmt_dec_last_week.sum(:valuation_settlement)
            @chubu_aupays_slmt_profit_last_week = @chubu_aupays_slmt_last_week.sum(:profit_settlement) - @chubu_aupays_slmt_def_last_week.sum(:profit_settlement) + @chubu_aupays_slmt_inc_last_week.sum(:profit_settlement) - @chubu_aupays_slmt_dec_last_week.sum(:profit_settlement)
          # paypay
            @chubu_paypay_user = Paypay.includes(:user).where(user: {base: "中部SS"})
            # 今月
            @chubu_paypays_this_month = @chubu_paypay_user.where(date: @results.minimum(:date)..@results.maximum(:date))
            @chubu_paypays_def_this_month = @chubu_paypay_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date)).where(deficiency_solution: nil)

            @chubu_paypays_valuation = @chubu_paypays_this_month.sum(:valuation) - @chubu_paypays_def_this_month.sum(:valuation)
            @chubu_paypay_profit = @chubu_paypays_this_month.sum(:profit) - @chubu_paypays_def_this_month.sum(:profit)
            # 前週
            @chubu_paypays_last_week = @chubu_paypay_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_paypays_def_last_week = @chubu_paypay_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days)).where(deficiency_solution: nil)

            @chubu_paypay_valuation_last_week = @chubu_paypays_last_week.sum(:valuation) - @chubu_paypays_def_last_week.sum(:valuation)
            @chubu_paypay_profit_last_week = @chubu_paypays_last_week.sum(:profit) - @chubu_paypays_def_last_week.sum(:profit)
          # 楽天ペイ
            @chubu_rakuten_pays_user = RakutenPay.includes(:user).where(user: {base: "中部SS"})
            # 今月
            @chubu_rakuten_pays_this_month = @chubu_rakuten_pays_user.where(date: @results.minimum(:date)..@results.maximum(:date))
            @chubu_rakuten_pays_not_this_month = @chubu_rakuten_pays_user.where.not(date: @results.minimum(:date)..@results.maximum(:date))
            @chubu_rakuten_pays_inc = @chubu_rakuten_pays_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
            @chubu_rakuten_pays_dec = @chubu_rakuten_pays_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
            @chubu_rakuten_pays_def_this_month = @chubu_rakuten_pays_this_month.where.not(deficiency: nil).where(deficiency_solution: nil)
            @chubu_rakuten_pays_no_def_this_month = @chubu_rakuten_pays_this_month.where(deficiency: nil).or(@chubu_rakuten_pays_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))

            @chubu_rakuten_pays_valuation = @chubu_rakuten_pays_this_month.sum(:valuation) - @chubu_rakuten_pays_def_this_month.sum(:valuation) + @chubu_rakuten_pays_inc.sum(:valuation) - @chubu_rakuten_pays_dec.sum(:valuation)
            @chubu_rakuten_pay_profit = @chubu_rakuten_pays_this_month.sum(:profit) - @chubu_rakuten_pays_def_this_month.sum(:profit) + @chubu_rakuten_pays_inc.sum(:profit) - @chubu_rakuten_pays_dec.sum(:profit)
            # 前週
            @chubu_rakuten_pays_last_week = @chubu_rakuten_pays_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_rakuten_pays_not_last_week = @chubu_rakuten_pays_user.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_rakuten_pays_inc_last_week = @chubu_rakuten_pays_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_rakuten_pays_dec_last_week = @chubu_rakuten_pays_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_rakuten_pays_def_last_week = @chubu_rakuten_pays_last_week.where.not(deficiency: nil).where(deficiency_solution: nil)
            @chubu_rakuten_pays_no_def_last_week = @chubu_rakuten_pays_last_week.where(deficiency: nil).or(@chubu_rakuten_pays_last_week.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

            @chubu_rakuten_pay_valuation_last_week = @chubu_rakuten_pays_last_week.sum(:valuation) - @chubu_rakuten_pays_def_last_week.sum(:valuation) + @chubu_rakuten_pays_inc_last_week.sum(:valuation) - @chubu_rakuten_pays_dec_last_week.sum(:valuation)
            @chubu_rakuten_pay_profit_last_week = @chubu_rakuten_pays_last_week.sum(:profit) - @chubu_rakuten_pays_def_last_week.sum(:profit) + @chubu_rakuten_pays_inc_last_week.sum(:profit) - @chubu_rakuten_pays_dec_last_week.sum(:profit)
          # 少額短期保険
            @chubu_st_insurances_user = StInsurance.includes(:user).where(user: {base: "中部SS"})
            # 今月
            @chubu_st_insurances_this_month = @chubu_st_insurances_user.where(date: @results.minimum(:date)..@results.maximum(:date))
            @chubu_st_insurances_def_this_month = @chubu_st_insurances_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date)).where(deficiency_solution: nil)

            @chubu_st_insurances_valuation = @chubu_st_insurances_this_month.sum(:valuation) - @chubu_st_insurances_def_this_month.sum(:valuation)
            @chubu_st_insurance_profit = @chubu_st_insurances_this_month.sum(:profit) - @chubu_st_insurances_def_this_month.sum(:profit)
            # 前週
            @chubu_st_insurances_last_week = @chubu_st_insurances_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_st_insurances_def_last_week = @chubu_st_insurances_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days)).where(deficiency_solution: nil)

            @chubu_st_insurance_valuation_last_week = @chubu_st_insurances_last_week.sum(:valuation) - @chubu_st_insurances_def_last_week.sum(:valuation)
            @chubu_st_insurance_profit_last_week = @chubu_st_insurances_last_week.sum(:profit) - @chubu_st_insurances_def_last_week.sum(:profit)
          # 中部キャッシュ合計売上
            # 評価売
            @chubu_cash_sum_valuation = @chubu_dmers_new_valuation + @chubu_dmers_slmt_valuation + @chubu_aupays_new_valuation + @chubu_aupays_slmt_valuation +
              @chubu_paypays_valuation + @chubu_rakuten_pays_valuation + @chubu_st_insurances_valuation
            @chubu_cash_sum_valuation_last_week = @chubu_dmers_new_valuation_last_week + @chubu_dmers_slmt_valuation_last_week +
              @chubu_aupay_new_valuation_last_week + @chubu_aupays_slmt_valuation_last_week + @chubu_paypay_valuation_last_week + @chubu_rakuten_pay_valuation_last_week + @chubu_st_insurance_valuation_last_week
              # 実売
              @chubu_cash_sum_profit = @chubu_dmers_new_profit + @chubu_dmers_slmt_profit + @chubu_aupay_new_profit + @chubu_aupays_slmt_profit + 
                @chubu_paypay_profit + @chubu_rakuten_pay_profit + @chubu_st_insurance_profit
              @chubu_cash_sum_profit_last_week = @chubu_dmers_new_profit_last_week + @chubu_dmers_slmt_profit_last_week +
                @chubu_aupay_new_profit_last_week + @chubu_aupays_slmt_profit_last_week + @chubu_paypay_profit_last_week + @chubu_rakuten_pay_profit_last_week + @chubu_st_insurance_profit_last_week
          # 楽天フェムト新規
            @chubu_rakuten_casas_user = RakutenCasa.includes(:user).where(user: {base: "中部SS"})
            # 今月
            @chubu_rakuten_casas_this_month = @chubu_rakuten_casas_user.where(date: @results.minimum(:date)..@results.maximum(:date))
            @chubu_rakuten_casas_not_this_month = @chubu_rakuten_casas_user.where.not(date: @results.minimum(:date)..@results.maximum(:date))
            @chubu_rakuten_casas_inc = @chubu_rakuten_casas_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
            @chubu_rakuten_casas_dec = @chubu_rakuten_casas_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))

            @chubu_rakuten_casas_def_this_month = @chubu_rakuten_casas_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@chubu_rakuten_casas_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))).or(@chubu_rakuten_casas_this_month.where.not(deficiency_net: nil).where(deficiency_solution_net: nil)).or(@chubu_rakuten_casas_this_month.where.not(deficiency_net: nil).where.not(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date))).or(@chubu_rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil)).or(@chubu_rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date)))

            @chubu_rakuten_casas_valuation = @chubu_rakuten_casas_this_month.sum(:valuation_new) - @chubu_rakuten_casas_def_this_month.sum(:valuation_new) +
              @chubu_rakuten_casas_inc.sum(:valuation_new) - @chubu_rakuten_casas_dec.sum(:valuation_new)
            @chubu_rakuten_casa_profit = @chubu_rakuten_casas_this_month.sum(:profit_new) - @chubu_rakuten_casas_def_this_month.sum(:profit_new) +
              @chubu_rakuten_casas_inc.sum(:profit_new) - @chubu_rakuten_casas_dec.sum(:profit_new)
            # 前週
            @chubu_rakuten_casas_last_week = @chubu_rakuten_casas_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_rakuten_casas_not_last_week = @chubu_rakuten_casas_user.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_rakuten_casas_inc_last_week = @chubu_rakuten_casas_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_rakuten_casas_dec_last_week = @chubu_rakuten_casas_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))

            @chubu_rakuten_casas_def_last_week = @chubu_rakuten_casas_last_week.where.not(deficiency: nil).where(deficiency_solution: nil).or(@chubu_rakuten_casas_last_week.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))).or(@chubu_rakuten_casas_last_week.where.not(deficiency_net: nil).where(deficiency_solution_net: nil)).or(@chubu_rakuten_casas_last_week.where.not(deficiency_net: nil).where.not(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date).ago(7.days))).or(@chubu_rakuten_casas_last_week.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil)).or(@chubu_rakuten_casas_last_week.where.not(deficiency_anti: nil).where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

            @chubu_rakuten_casa_valuation_last_week = @chubu_rakuten_casas_last_week.sum(:valuation_new) - @chubu_rakuten_casas_def_last_week.sum(:valuation_new) + @chubu_rakuten_casas_inc_last_week.sum(:valuation_new) - @chubu_rakuten_casas_dec_last_week.sum(:valuation_new)
            @chubu_rakuten_casa_profit_last_week = @chubu_rakuten_casas_last_week.sum(:profit_new) - @chubu_rakuten_casas_def_last_week.sum(:profit_new) + @chubu_rakuten_casas_inc_last_week.sum(:profit_new) - @chubu_rakuten_casas_dec_last_week.sum(:profit_new)
          # 楽天フェムト設置
            # 今月
            @chubu_rakuten_casa_put = @chubu_rakuten_casas_user.where(put: @results.minimum(:date)..@results.maximum(:date))
            @chubu_rakuten_casas_put_valuation = @chubu_rakuten_casa_put.sum(:valuation_put)
            @chubu_rakuten_casa_put_profit = @chubu_rakuten_casa_put.sum(:profit_put)
            # 前週
            @chubu_rakuten_casas_put_last_week = @chubu_rakuten_casas_user.where(put: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @chubu_rakuten_casa_put_valuation_last_week = @chubu_rakuten_casas_put_last_week.sum(:profit_put)
            @chubu_rakuten_casa_put_profit_last_week = @chubu_rakuten_casas_put_last_week.sum(:profit_put)
          # 中部フェムト合計売上
          # 評価売
            @chubu_rakuten_casa_valuation_sum = @chubu_rakuten_casas_valuation + @chubu_rakuten_casas_put_valuation
            @chubu_rakuten_casa_valuation_sum_last_week = @chubu_rakuten_casa_valuation_last_week + @chubu_rakuten_casa_put_valuation_last_week
          # 実売
            @chubu_rakuten_casa_profit_sum = @chubu_rakuten_casa_profit + @chubu_rakuten_casa_put_profit
            @chubu_rakuten_casa_profit_sum_last_week = @chubu_rakuten_casa_profit_last_week + @chubu_rakuten_casa_put_profit_last_week
        # 関東
          # dメル新規
            @kanto_dmer_users = Dmer.includes(:user).where(user: {base: "関東SS"})
            # 今月
            @kanto_dmers_this_month = @kanto_dmer_users.where(date: @results.minimum(:date)..@results.maximum(:date))
            @kanto_dmers_not_this_month = @kanto_dmer_users.where.not(date: @results.minimum(:date)..@results.maximum(:date))
            @kanto_dmers_inc = @kanto_dmers_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
            @kanto_dmers_dec = @kanto_dmers_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
            @kanto_dmers_def_this_month = @kanto_dmers_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kanto_dmers_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
            @kanto_dmers_no_def_this_month = @kanto_dmers_this_month.where(deficiency: nil).or(@kanto_dmers_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
  
            @kanto_dmers_new_valuation = @kanto_dmers_this_month.sum(:valuation_new) - @kanto_dmers_def_this_month.sum(:valuation_new) + @kanto_dmers_inc.sum(:valuation_new) - @kanto_dmers_dec.sum(:valuation_new)
            @kanto_dmers_new_profit = @kanto_dmers_this_month.sum(:profit_new) - @kanto_dmers_def_this_month.sum(:profit_new) + @kanto_dmers_inc.sum(:valuation_new) - @kanto_dmers_dec.sum(:profit_new)
            # 前週
            @kanto_dmers_last_week = @kanto_dmer_users.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_dmers_not_last_week = @kanto_dmer_users.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_dmers_inc_last_week = @kanto_dmers_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_dmers_dec_last_week = @kanto_dmers_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_dmers_def_last_week = @kanto_dmers_last_week.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kanto_dmers_last_week.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
            @kanto_dmers_no_def_last_week = @kanto_dmers_last_week.where(deficiency: nil).or(@kanto_dmers_last_week.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
  
            @kanto_dmers_new_valuation_last_week = @kanto_dmers_last_week.sum(:valuation_new) - @kanto_dmers_def_last_week.sum(:valuation_new) + @kanto_dmers_inc_last_week.sum(:valuation_new) - @kanto_dmers_dec_last_week.sum(:valuation_new)
            @kanto_dmers_new_profit_last_week = @kanto_dmers_last_week.sum(:profit_new) - @kanto_dmers_def_last_week.sum(:profit_new) + @kanto_dmers_inc_last_week.sum(:profit_new) - @kanto_dmers_dec_last_week.sum(:profit_new)
          # dメル決済
            # 今月
            @kanto_dmers_slmt_this_month = @kanto_dmer_users.where(settlement: @results.minimum(:date)..@results.maximum(:date))
            @kanto_dmers_slmt_not_this_month = @kanto_dmer_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date))
            @kanto_dmers_slmt_inc = @kanto_dmers_slmt_not_this_month.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date))
            @kanto_dmers_slmt_dec = @kanto_dmers_slmt_not_this_month.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date))
            @kanto_dmers_slmt_def_this_month = @kanto_dmers_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@kanto_dmers_slmt_this_month.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
            @kanto_dmers_slmt_no_def_this_month = @kanto_dmers_slmt_this_month.where(deficiency_settlement: nil).or(@kanto_dmers_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
  
            @kanto_dmers_slmt_valuation = @kanto_dmers_slmt_this_month.sum(:valuation_settlement) - @kanto_dmers_slmt_def_this_month.sum(:valuation_settlement) + @kanto_dmers_slmt_inc.sum(:valuation_settlement) - @kanto_dmers_slmt_dec.sum(:valuation_settlement)
            @kanto_dmers_slmt_profit = @kanto_dmers_slmt_this_month.sum(:profit_settlement) - @kanto_dmers_slmt_def_this_month.sum(:profit_settlement) + @kanto_dmers_slmt_inc.sum(:profit_settlement) - @kanto_dmers_slmt_dec.sum(:profit_settlement)
            # 前週
            @kanto_dmers_slmt_last_week = @kanto_dmer_users.where(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_dmers_slmt_not_last_week = @kanto_dmer_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_dmers_slmt_inc_last_week = @kanto_dmers_slmt_not_last_week.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_dmers_slmt_dec_last_week = @kanto_dmers_slmt_not_last_week.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_dmers_slmt_def_last_week = @kanto_dmers_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@kanto_dmers_slmt_last_week.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
            @kanto_dmers_slmt_no_def_last_week = @kanto_dmers_slmt_last_week.where(deficiency_settlement: nil).or(@kanto_dmers_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
  
            @kanto_dmers_slmt_valuation_last_week = @kanto_dmers_slmt_last_week.sum(:valuation_settlement) - @kanto_dmers_slmt_def_last_week.sum(:valuation_settlement) + @kanto_dmers_slmt_inc_last_week.sum(:valuation_settlement) - @kanto_dmers_slmt_dec_last_week.sum(:valuation_settlement)
            @kanto_dmers_slmt_profit_last_week = @kanto_dmers_slmt_last_week.sum(:profit_settlement) - @kanto_dmers_slmt_def_last_week.sum(:profit_settlement) + @kanto_dmers_slmt_inc_last_week.sum(:profit_settlement) - @kanto_dmers_slmt_dec_last_week.sum(:profit_settlement)
          # aupay新規
            # 今月
            @kanto_aupay_users = Aupay.includes(:user).where(user: {base: "関東SS"})
            @kanto_aupays_this_month = @kanto_aupay_users.where(date: @results.minimum(:date)..@results.maximum(:date))
            @kanto_aupays_not_this_month = @kanto_aupay_users.where.not(date: @results.minimum(:date)..@results.maximum(:date))
            @kanto_aupays_inc = @kanto_aupays_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
            @kanto_aupays_dec = @kanto_aupays_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
            @kanto_aupays_def_this_month = @kanto_aupays_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kanto_aupays_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
            @kanto_aupays_no_def_this_month = @kanto_aupays_this_month.where(deficiency: nil).or(@kanto_aupays_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
  
            @kanto_aupay_new_valuation = @kanto_aupays_this_month.sum(:valuation_new) - @kanto_aupays_def_this_month.sum(:valuation_new) + @kanto_aupays_inc.sum(:valuation_new) - @kanto_aupays_dec.sum(:valuation_new)
            @kanto_aupay_new_profit = @kanto_aupays_this_month.sum(:profit_new) - @kanto_aupays_def_this_month.sum(:profit_new) + @kanto_aupays_inc.sum(:valuation_new) - @kanto_aupays_dec.sum(:profit_new)
            # 前週
            @kanto_aupays_last_week = @kanto_aupay_users.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_aupays_not_last_week = @kanto_aupay_users.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_aupays_inc_last_week = @kanto_aupays_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_aupays_dec_last_week = @kanto_aupays_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_aupays_def_last_week = @kanto_aupays_last_week.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kanto_aupays_last_week.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
            @kanto_aupays_no_def_last_week = @kanto_aupays_last_week.where(deficiency: nil).or(@kanto_aupays_last_week.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
  
            @kanto_aupay_new_valuation_last_week = @kanto_aupays_last_week.sum(:valuation_new) - @kanto_aupays_def_last_week.sum(:valuation_new) + @kanto_aupays_inc_last_week.sum(:valuation_new) - @kanto_aupays_dec_last_week.sum(:valuation_new)
            @kanto_aupay_new_profit_last_week = @kanto_aupays_last_week.sum(:profit_new) - @kanto_aupays_def_last_week.sum(:profit_new) + @kanto_aupays_inc_last_week.sum(:profit_new) - @kanto_aupays_dec_last_week.sum(:profit_new)
          # aupay決済
            # 今月
            @kanto_aupays_slmt_this_month = @kanto_aupay_users.where(settlement: @results.minimum(:date)..@results.maximum(:date))
            @kanto_aupays_slmt_not_this_month = @kanto_aupay_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date))
            @kanto_aupays_slmt_inc = @kanto_aupays_slmt_not_this_month.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date))
            @kanto_aupays_slmt_dec = @kanto_aupays_slmt_not_this_month.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date))
            @kanto_aupays_slmt_def_this_month = @kanto_aupays_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@kanto_aupays_slmt_this_month.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
            @kanto_aupays_slmt_no_def_this_month = @kanto_aupays_slmt_this_month.where(deficiency_settlement: nil).or(@kanto_aupays_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
  
            @kanto_aupays_slmt_valuation = @kanto_aupays_slmt_this_month.sum(:valuation_settlement) - @kanto_aupays_slmt_def_this_month.sum(:valuation_settlement) + @kanto_aupays_slmt_inc.sum(:valuation_settlement) - @kanto_aupays_slmt_dec.sum(:valuation_settlement)
            @kanto_aupays_slmt_profit = @kanto_aupays_slmt_this_month.sum(:profit_settlement) - @kanto_aupays_slmt_def_this_month.sum(:profit_settlement) + @kanto_aupays_slmt_inc.sum(:profit_settlement) - @kanto_aupays_slmt_dec.sum(:profit_settlement)
            # 前週
            @kanto_aupays_slmt_last_week = @kanto_aupay_users.where(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_aupays_slmt_not_last_week = @kanto_aupay_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_aupays_slmt_inc_last_week = @kanto_aupays_slmt_not_last_week.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_aupays_slmt_dec_last_week = @kanto_aupays_slmt_not_last_week.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_aupays_slmt_def_last_week = @kanto_aupays_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@kanto_aupays_slmt_last_week.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
            @kanto_aupays_slmt_no_def_last_week = @kanto_aupays_slmt_last_week.where(deficiency_settlement: nil).or(@kanto_aupays_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
  
            @kanto_aupays_slmt_valuation_last_week = @kanto_aupays_slmt_last_week.sum(:valuation_settlement) - @kanto_aupays_slmt_def_last_week.sum(:valuation_settlement) + @kanto_aupays_slmt_inc_last_week.sum(:valuation_settlement) - @kanto_aupays_slmt_dec_last_week.sum(:valuation_settlement)
            @kanto_aupays_slmt_profit_last_week = @kanto_aupays_slmt_last_week.sum(:profit_settlement) - @kanto_aupays_slmt_def_last_week.sum(:profit_settlement) + @kanto_aupays_slmt_inc_last_week.sum(:profit_settlement) - @kanto_aupays_slmt_dec_last_week.sum(:profit_settlement)
          # paypay
            @kanto_paypay_user = Paypay.includes(:user).where(user: {base: "関東SS"})
            # 今月
            @kanto_paypays_this_month = @kanto_paypay_user.where(date: @results.minimum(:date)..@results.maximum(:date))
            @kanto_paypays_def_this_month = @kanto_paypay_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date)).where(deficiency_solution: nil)
  
            @kanto_paypay_valuation = @kanto_paypays_this_month.sum(:valuation) - @kanto_paypays_def_this_month.sum(:valuation)
            @kanto_paypay_profit = @kanto_paypays_this_month.sum(:profit) - @kanto_paypays_def_this_month.sum(:profit)
            # 前週
            @kanto_paypays_last_week = @kanto_paypay_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_paypays_def_last_week = @kanto_paypay_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days)).where(deficiency_solution: nil)
  
            @kanto_paypay_valuation_last_week = @kanto_paypays_last_week.sum(:valuation) - @kanto_paypays_def_last_week.sum(:valuation)
            @kanto_paypay_profit_last_week = @kanto_paypays_last_week.sum(:profit) - @kanto_paypays_def_last_week.sum(:profit)
          # 楽天ペイ
            @kanto_rakuten_pays_user = RakutenPay.includes(:user).where(user: {base: "関東SS"})
            # 今月
            @kanto_rakuten_pays_this_month = @kanto_rakuten_pays_user.where(date: @results.minimum(:date)..@results.maximum(:date))
            @kanto_rakuten_pays_not_this_month = @kanto_rakuten_pays_user.where.not(date: @results.minimum(:date)..@results.maximum(:date))
            @kanto_rakuten_pays_inc = @kanto_rakuten_pays_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
            @kanto_rakuten_pays_dec = @kanto_rakuten_pays_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
            @kanto_rakuten_pays_def_this_month = @kanto_rakuten_pays_this_month.where.not(deficiency: nil).where(deficiency_solution: nil)
            @kanto_rakuten_pays_no_def_this_month = @kanto_rakuten_pays_this_month.where(deficiency: nil).or(@kanto_rakuten_pays_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
  
            @kanto_rakuten_pay_valuation = @kanto_rakuten_pays_this_month.sum(:valuation) - @kanto_rakuten_pays_def_this_month.sum(:valuation) + @kanto_rakuten_pays_inc.sum(:valuation) - @kanto_rakuten_pays_dec.sum(:valuation)
            @kanto_rakuten_pay_profit = @kanto_rakuten_pays_this_month.sum(:profit) - @kanto_rakuten_pays_def_this_month.sum(:profit) + @kanto_rakuten_pays_inc.sum(:profit) - @kanto_rakuten_pays_dec.sum(:profit)
            # 前週
            @kanto_rakuten_pays_last_week = @kanto_rakuten_pays_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_rakuten_pays_not_last_week = @kanto_rakuten_pays_user.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_rakuten_pays_inc_last_week = @kanto_rakuten_pays_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_rakuten_pays_dec_last_week = @kanto_rakuten_pays_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_rakuten_pays_def_last_week = @kanto_rakuten_pays_last_week.where.not(deficiency: nil).where(deficiency_solution: nil)
            @kanto_rakuten_pays_no_def_last_week = @kanto_rakuten_pays_last_week.where(deficiency: nil).or(@kanto_rakuten_pays_last_week.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
  
            @kanto_rakuten_pay_valuation_last_week = @kanto_rakuten_pays_last_week.sum(:valuation) - @kanto_rakuten_pays_def_last_week.sum(:valuation) + @kanto_rakuten_pays_inc_last_week.sum(:valuation) - @kanto_rakuten_pays_dec_last_week.sum(:valuation)
            @kanto_rakuten_pay_profit_last_week = @kanto_rakuten_pays_last_week.sum(:profit) - @kanto_rakuten_pays_def_last_week.sum(:profit) + @kanto_rakuten_pays_inc_last_week.sum(:profit) - @kanto_rakuten_pays_dec_last_week.sum(:profit)
          # 少額短期保険
            @kanto_st_insurances_user = StInsurance.includes(:user).where(user: {base: "関東SS"})
            # 今月
            @kanto_st_insurances_this_month = @kanto_st_insurances_user.where(date: @results.minimum(:date)..@results.maximum(:date))
            @kanto_st_insurances_def_this_month = @kanto_st_insurances_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date)).where(deficiency_solution: nil)
  
            @kanto_st_insurance_valuation = @kanto_st_insurances_this_month.sum(:valuation) - @kanto_st_insurances_def_this_month.sum(:valuation)
            @kanto_st_insurance_profit = @kanto_st_insurances_this_month.sum(:profit) - @kanto_st_insurances_def_this_month.sum(:profit)
            # 前週
            @kanto_st_insurances_last_week = @kanto_st_insurances_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_st_insurances_def_last_week = @kanto_st_insurances_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days)).where(deficiency_solution: nil)
  
            @kanto_st_insurance_valuation_last_week = @kanto_st_insurances_last_week.sum(:valuation) - @kanto_st_insurances_def_last_week.sum(:valuation)
            @kanto_st_insurance_profit_last_week = @kanto_st_insurances_last_week.sum(:profit) - @kanto_st_insurances_def_last_week.sum(:profit)
          # 中部キャッシュ合計売上
            # 評価売
            @kanto_cash_sum_valuation = @kanto_dmers_new_valuation + @kanto_dmers_slmt_valuation + @kanto_aupay_new_valuation + @kanto_aupays_slmt_valuation +
              @kanto_paypay_valuation + @kanto_rakuten_pay_valuation + @kanto_st_insurance_valuation
            @kanto_cash_sum_valuation_last_week = @kanto_dmers_new_valuation_last_week + @kanto_dmers_slmt_valuation_last_week +
              @kanto_aupay_new_valuation_last_week + @kanto_aupays_slmt_valuation_last_week + @kanto_paypay_valuation_last_week + @kanto_rakuten_pay_valuation_last_week + @kanto_st_insurance_valuation_last_week
              # 実売
              @kanto_cash_sum_profit = @kanto_dmers_new_profit + @kanto_dmers_slmt_profit + @kanto_aupay_new_profit + @kanto_aupays_slmt_profit + 
                @kanto_paypay_profit + @kanto_rakuten_pay_profit + @kanto_st_insurance_profit
              @kanto_cash_sum_profit_last_week = @kanto_dmers_new_profit_last_week + @kanto_dmers_slmt_profit_last_week +
                @kanto_aupay_new_profit_last_week + @kanto_aupays_slmt_profit_last_week + @kanto_paypay_profit_last_week + @kanto_rakuten_pay_profit_last_week + @kanto_st_insurance_profit_last_week
          # 楽天フェムト新規
            @kanto_rakuten_casas_user = RakutenCasa.includes(:user).where(user: {base: "関東SS"})
            # 今月
            @kanto_rakuten_casas_this_month = @kanto_rakuten_casas_user.where(date: @results.minimum(:date)..@results.maximum(:date))
            @kanto_rakuten_casas_not_this_month = @kanto_rakuten_casas_user.where.not(date: @results.minimum(:date)..@results.maximum(:date))
            @kanto_rakuten_casas_inc = @kanto_rakuten_casas_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
            @kanto_rakuten_casas_dec = @kanto_rakuten_casas_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
  
            @kanto_rakuten_casas_def_this_month = @kanto_rakuten_casas_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kanto_rakuten_casas_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))).or(@kanto_rakuten_casas_this_month.where.not(deficiency_net: nil).where(deficiency_solution_net: nil)).or(@kanto_rakuten_casas_this_month.where.not(deficiency_net: nil).where.not(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date))).or(@kanto_rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil)).or(@kanto_rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date)))
  
            @kanto_rakuten_casa_valuation = @kanto_rakuten_casas_this_month.sum(:valuation_new) - @kanto_rakuten_casas_def_this_month.sum(:valuation_new) +
              @kanto_rakuten_casas_inc.sum(:valuation_new) - @kanto_rakuten_casas_dec.sum(:valuation_new)
            @kanto_rakuten_casa_profit = @kanto_rakuten_casas_this_month.sum(:profit_new) - @kanto_rakuten_casas_def_this_month.sum(:profit_new) +
              @kanto_rakuten_casas_inc.sum(:profit_new) - @kanto_rakuten_casas_dec.sum(:profit_new)
            # 前週
            @kanto_rakuten_casas_last_week = @kanto_rakuten_casas_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_rakuten_casas_not_last_week = @kanto_rakuten_casas_user.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_rakuten_casas_inc_last_week = @kanto_rakuten_casas_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_rakuten_casas_dec_last_week = @kanto_rakuten_casas_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
  
            @kanto_rakuten_casas_def_last_week = @kanto_rakuten_casas_last_week.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kanto_rakuten_casas_last_week.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))).or(@kanto_rakuten_casas_last_week.where.not(deficiency_net: nil).where(deficiency_solution_net: nil)).or(@kanto_rakuten_casas_last_week.where.not(deficiency_net: nil).where.not(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date).ago(7.days))).or(@kanto_rakuten_casas_last_week.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil)).or(@kanto_rakuten_casas_last_week.where.not(deficiency_anti: nil).where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
  
            @kanto_rakuten_casa_valuation_last_week = @kanto_rakuten_casas_last_week.sum(:valuation_new) - @kanto_rakuten_casas_def_last_week.sum(:valuation_new) + @kanto_rakuten_casas_inc_last_week.sum(:valuation_new) - @kanto_rakuten_casas_dec_last_week.sum(:valuation_new)
            @kanto_rakuten_casa_profit_last_week = @kanto_rakuten_casas_last_week.sum(:profit_new) - @kanto_rakuten_casas_def_last_week.sum(:profit_new) + @kanto_rakuten_casas_inc_last_week.sum(:profit_new) - @kanto_rakuten_casas_dec_last_week.sum(:profit_new)
          # 楽天フェムト設置
            # 今月
            @kanto_rakuten_casa_put = @kanto_rakuten_casas_user.where(put: @results.minimum(:date)..@results.maximum(:date))
            @kanto_rakuten_casa_put_valuation = @kanto_rakuten_casa_put.sum(:valuation_put)
            @kanto_rakuten_casa_put_profit = @kanto_rakuten_casa_put.sum(:profit_put)
            # 前週
            @kanto_rakuten_casas_put_last_week = @kanto_rakuten_casas_user.where(put: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
            @kanto_rakuten_casa_put_valuation_last_week = @kanto_rakuten_casas_put_last_week.sum(:profit_put)
            @kanto_rakuten_casa_put_profit_last_week = @kanto_rakuten_casas_put_last_week.sum(:profit_put)
          # 中部フェムト合計売上
          # 評価売
          @kanto_rakuten_casa_valuation_sum = @kanto_rakuten_casa_valuation + @kanto_rakuten_casa_put_valuation
          @kanto_rakuten_casa_valuation_sum_last_week = @kanto_rakuten_casa_valuation_last_week + @kanto_rakuten_casa_put_valuation_last_week
          # 実売
          @kanto_rakuten_casa_profit_sum = @kanto_rakuten_casa_profit + @kanto_rakuten_casa_put_profit
          @kanto_rakuten_casa_profit_sum_last_week = @kanto_rakuten_casa_profit_last_week + @kanto_rakuten_casa_put_profit_last_week
        # 関西
        # dメル新規
          @kansai_dmer_users = Dmer.includes(:user).where(user: {base: "関西SS"})
          # 今月
          @kansai_dmers_this_month = @kansai_dmer_users.where(date: @results.minimum(:date)..@results.maximum(:date))
          @kansai_dmers_not_this_month = @kansai_dmer_users.where.not(date: @results.minimum(:date)..@results.maximum(:date))
          @kansai_dmers_inc = @kansai_dmers_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
          @kansai_dmers_dec = @kansai_dmers_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
          @kansai_dmers_def_this_month = @kansai_dmers_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kansai_dmers_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
          @kansai_dmers_no_def_this_month = @kansai_dmers_this_month.where(deficiency: nil).or(@kansai_dmers_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))

          @kansai_dmers_new_valuation = @kansai_dmers_this_month.sum(:valuation_new) - @kansai_dmers_def_this_month.sum(:valuation_new) + @kansai_dmers_inc.sum(:valuation_new) - @kansai_dmers_dec.sum(:valuation_new)
          @kansai_dmers_new_profit = @kansai_dmers_this_month.sum(:profit_new) - @kansai_dmers_def_this_month.sum(:profit_new) + @kansai_dmers_inc.sum(:valuation_new) - @kansai_dmers_dec.sum(:profit_new)
          # 前週
          @kansai_dmers_last_week = @kansai_dmer_users.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_dmers_not_last_week = @kansai_dmer_users.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_dmers_inc_last_week = @kansai_dmers_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_dmers_dec_last_week = @kansai_dmers_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_dmers_def_last_week = @kansai_dmers_last_week.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kansai_dmers_last_week.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
          @kansai_dmers_no_def_last_week = @kansai_dmers_last_week.where(deficiency: nil).or(@kansai_dmers_last_week.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

          @kansai_dmers_new_valuation_last_week = @kansai_dmers_last_week.sum(:valuation_new) - @kansai_dmers_def_last_week.sum(:valuation_new) + @kansai_dmers_inc_last_week.sum(:valuation_new) - @kansai_dmers_dec_last_week.sum(:valuation_new)
          @kansai_dmers_new_profit_last_week = @kansai_dmers_last_week.sum(:profit_new) - @kansai_dmers_def_last_week.sum(:profit_new) + @kansai_dmers_inc_last_week.sum(:profit_new) - @kansai_dmers_dec_last_week.sum(:profit_new)
        # dメル決済
          # 今月
          @kansai_dmers_slmt_this_month = @kansai_dmer_users.where(settlement: @results.minimum(:date)..@results.maximum(:date))
          @kansai_dmers_slmt_not_this_month = @kansai_dmer_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date))
          @kansai_dmers_slmt_inc = @kansai_dmers_slmt_not_this_month.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date))
          @kansai_dmers_slmt_dec = @kansai_dmers_slmt_not_this_month.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date))
          @kansai_dmers_slmt_def_this_month = @kansai_dmers_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@kansai_dmers_slmt_this_month.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
          @kansai_dmers_slmt_no_def_this_month = @kansai_dmers_slmt_this_month.where(deficiency_settlement: nil).or(@kansai_dmers_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))

          @kansai_dmers_slmt_valuation = @kansai_dmers_slmt_this_month.sum(:valuation_settlement) - @kansai_dmers_slmt_def_this_month.sum(:valuation_settlement) + @kansai_dmers_slmt_inc.sum(:valuation_settlement) - @kansai_dmers_slmt_dec.sum(:valuation_settlement)
          @kansai_dmers_slmt_profit = @kansai_dmers_slmt_this_month.sum(:profit_settlement) - @kansai_dmers_slmt_def_this_month.sum(:profit_settlement) + @kansai_dmers_slmt_inc.sum(:profit_settlement) - @kansai_dmers_slmt_dec.sum(:profit_settlement)
          # 前週
          @kansai_dmers_slmt_last_week = @kansai_dmer_users.where(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_dmers_slmt_not_last_week = @kansai_dmer_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_dmers_slmt_inc_last_week = @kansai_dmers_slmt_not_last_week.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_dmers_slmt_dec_last_week = @kansai_dmers_slmt_not_last_week.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_dmers_slmt_def_last_week = @kansai_dmers_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@kansai_dmers_slmt_last_week.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
          @kansai_dmers_slmt_no_def_last_week = @kansai_dmers_slmt_last_week.where(deficiency_settlement: nil).or(@kansai_dmers_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

          @kansai_dmers_slmt_valuation_last_week = @kansai_dmers_slmt_last_week.sum(:valuation_settlement) - @kansai_dmers_slmt_def_last_week.sum(:valuation_settlement) + @kansai_dmers_slmt_inc_last_week.sum(:valuation_settlement) - @kansai_dmers_slmt_dec_last_week.sum(:valuation_settlement)
          @kansai_dmers_slmt_profit_last_week = @kansai_dmers_slmt_last_week.sum(:profit_settlement) - @kansai_dmers_slmt_def_last_week.sum(:profit_settlement) + @kansai_dmers_slmt_inc_last_week.sum(:profit_settlement) - @kansai_dmers_slmt_dec_last_week.sum(:profit_settlement)
        # aupay新規
          # 今月
          @kansai_aupay_users = Aupay.includes(:user).where(user: {base: "関西SS"})
          @kansai_aupays_this_month = @kansai_aupay_users.where(date: @results.minimum(:date)..@results.maximum(:date))
          @kansai_aupays_not_this_month = @kansai_aupay_users.where.not(date: @results.minimum(:date)..@results.maximum(:date))
          @kansai_aupays_inc = @kansai_aupays_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
          @kansai_aupays_dec = @kansai_aupays_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
          @kansai_aupays_def_this_month = @kansai_aupays_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kansai_aupays_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
          @kansai_aupays_no_def_this_month = @kansai_aupays_this_month.where(deficiency: nil).or(@kansai_aupays_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))

          @kansai_aupay_new_valuation = @kansai_aupays_this_month.sum(:valuation_new) - @kansai_aupays_def_this_month.sum(:valuation_new) + @kansai_aupays_inc.sum(:valuation_new) - @kansai_aupays_dec.sum(:valuation_new)
          @kansai_aupay_new_profit = @kansai_aupays_this_month.sum(:profit_new) - @kansai_aupays_def_this_month.sum(:profit_new) + @kansai_aupays_inc.sum(:valuation_new) - @kansai_aupays_dec.sum(:profit_new)
          # 前週
          @kansai_aupays_last_week = @kansai_aupay_users.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_aupays_not_last_week = @kansai_aupay_users.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_aupays_inc_last_week = @kansai_aupays_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_aupays_dec_last_week = @kansai_aupays_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_aupays_def_last_week = @kansai_aupays_last_week.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kansai_aupays_last_week.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
          @kansai_aupays_no_def_last_week = @kansai_aupays_last_week.where(deficiency: nil).or(@kansai_aupays_last_week.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

          @kansai_aupay_new_valuation_last_week = @kansai_aupays_last_week.sum(:valuation_new) - @kansai_aupays_def_last_week.sum(:valuation_new) + @kansai_aupays_inc_last_week.sum(:valuation_new) - @kansai_aupays_dec_last_week.sum(:valuation_new)
          @kansai_aupay_new_profit_last_week = @kansai_aupays_last_week.sum(:profit_new) - @kansai_aupays_def_last_week.sum(:profit_new) + @kansai_aupays_inc_last_week.sum(:profit_new) - @kansai_aupays_dec_last_week.sum(:profit_new)
        # aupay決済
          # 今月
          @kansai_aupays_slmt_this_month = @kansai_aupay_users.where(settlement: @results.minimum(:date)..@results.maximum(:date))
          @kansai_aupays_slmt_not_this_month = @kansai_aupay_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date))
          @kansai_aupays_slmt_inc = @kansai_aupays_slmt_not_this_month.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date))
          @kansai_aupays_slmt_dec = @kansai_aupays_slmt_not_this_month.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date))
          @kansai_aupays_slmt_def_this_month = @kansai_aupays_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@kansai_aupays_slmt_this_month.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
          @kansai_aupays_slmt_no_def_this_month = @kansai_aupays_slmt_this_month.where(deficiency_settlement: nil).or(@kansai_aupays_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))

          @kansai_aupays_slmt_valuation = @kansai_aupays_slmt_this_month.sum(:valuation_settlement) - @kansai_aupays_slmt_def_this_month.sum(:valuation_settlement) + @kansai_aupays_slmt_inc.sum(:valuation_settlement) - @kansai_aupays_slmt_dec.sum(:valuation_settlement)
          @kansai_aupays_slmt_profit = @kansai_aupays_slmt_this_month.sum(:profit_settlement) - @kansai_aupays_slmt_def_this_month.sum(:profit_settlement) + @kansai_aupays_slmt_inc.sum(:profit_settlement) - @kansai_aupays_slmt_dec.sum(:profit_settlement)
          # 前週
          @kansai_aupays_slmt_last_week = @kansai_aupay_users.where(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_aupays_slmt_not_last_week = @kansai_aupay_users.where.not(settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_aupays_slmt_inc_last_week = @kansai_aupays_slmt_not_last_week.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_aupays_slmt_dec_last_week = @kansai_aupays_slmt_not_last_week.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_aupays_slmt_def_last_week = @kansai_aupays_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@kansai_aupays_slmt_last_week.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))
          @kansai_aupays_slmt_no_def_last_week = @kansai_aupays_slmt_last_week.where(deficiency_settlement: nil).or(@kansai_aupays_slmt_last_week.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

          @kansai_aupays_slmt_valuation_last_week = @kansai_aupays_slmt_last_week.sum(:valuation_settlement) - @kansai_aupays_slmt_def_last_week.sum(:valuation_settlement) + @kansai_aupays_slmt_inc_last_week.sum(:valuation_settlement) - @kansai_aupays_slmt_dec_last_week.sum(:valuation_settlement)
          @kansai_aupays_slmt_profit_last_week = @kansai_aupays_slmt_last_week.sum(:profit_settlement) - @kansai_aupays_slmt_def_last_week.sum(:profit_settlement) + @kansai_aupays_slmt_inc_last_week.sum(:profit_settlement) - @kansai_aupays_slmt_dec_last_week.sum(:profit_settlement)
        # paypay
          @kansai_paypay_user = Paypay.includes(:user).where(user: {base: "関西SS"})
          # 今月
          @kansai_paypays_this_month = @kansai_paypay_user.where(date: @results.minimum(:date)..@results.maximum(:date))
          @kansai_paypays_def_this_month = @kansai_paypay_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date)).where(deficiency_solution: nil)

          @kansai_paypay_valuation = @kansai_paypays_this_month.sum(:valuation) - @kansai_paypays_def_this_month.sum(:valuation)
          @kansai_paypay_profit = @kansai_paypays_this_month.sum(:profit) - @kansai_paypays_def_this_month.sum(:profit)
          # 前週
          @kansai_paypays_last_week = @kansai_paypay_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_paypays_def_last_week = @kansai_paypay_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days)).where(deficiency_solution: nil)

          @kansai_paypay_valuation_last_week = @kansai_paypays_last_week.sum(:valuation) - @kansai_paypays_def_last_week.sum(:valuation)
          @kansai_paypay_profit_last_week = @kansai_paypays_last_week.sum(:profit) - @kansai_paypays_def_last_week.sum(:profit)
        # 楽天ペイ
          @kansai_rakuten_pays_user = RakutenPay.includes(:user).where(user: {base: "関西SS"})
          # 今月
          @kansai_rakuten_pays_this_month = @kansai_rakuten_pays_user.where(date: @results.minimum(:date)..@results.maximum(:date))
          @kansai_rakuten_pays_not_this_month = @kansai_rakuten_pays_user.where.not(date: @results.minimum(:date)..@results.maximum(:date))
          @kansai_rakuten_pays_inc = @kansai_rakuten_pays_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
          @kansai_rakuten_pays_dec = @kansai_rakuten_pays_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
          @kansai_rakuten_pays_def_this_month = @kansai_rakuten_pays_this_month.where.not(deficiency: nil).where(deficiency_solution: nil)
          @kansai_rakuten_pays_no_def_this_month = @kansai_rakuten_pays_this_month.where(deficiency: nil).or(@kansai_rakuten_pays_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))

          @kansai_rakuten_pay_valuation = @kansai_rakuten_pays_this_month.sum(:valuation) - @kansai_rakuten_pays_def_this_month.sum(:valuation) + @kansai_rakuten_pays_inc.sum(:valuation) - @kansai_rakuten_pays_dec.sum(:valuation)
          @kansai_rakuten_pay_profit = @kansai_rakuten_pays_this_month.sum(:profit) - @kansai_rakuten_pays_def_this_month.sum(:profit) + @kansai_rakuten_pays_inc.sum(:profit) - @kansai_rakuten_pays_dec.sum(:profit)
          # 前週
          @kansai_rakuten_pays_last_week = @kansai_rakuten_pays_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_rakuten_pays_not_last_week = @kansai_rakuten_pays_user.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_rakuten_pays_inc_last_week = @kansai_rakuten_pays_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_rakuten_pays_dec_last_week = @kansai_rakuten_pays_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_rakuten_pays_def_last_week = @kansai_rakuten_pays_last_week.where.not(deficiency: nil).where(deficiency_solution: nil)
          @kansai_rakuten_pays_no_def_last_week = @kansai_rakuten_pays_last_week.where(deficiency: nil).or(@kansai_rakuten_pays_last_week.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

          @kansai_rakuten_pay_valuation_last_week = @kansai_rakuten_pays_last_week.sum(:valuation) - @kansai_rakuten_pays_def_last_week.sum(:valuation) + @kansai_rakuten_pays_inc_last_week.sum(:valuation) - @kansai_rakuten_pays_dec_last_week.sum(:valuation)
          @kansai_rakuten_pay_profit_last_week = @kansai_rakuten_pays_last_week.sum(:profit) - @kansai_rakuten_pays_def_last_week.sum(:profit) + @kansai_rakuten_pays_inc_last_week.sum(:profit) - @kansai_rakuten_pays_dec_last_week.sum(:profit)
        # 少額短期保険
          @kansai_st_insurances_user = StInsurance.includes(:user).where(user: {base: "関西SS"})
          # 今月
          @kansai_st_insurances_this_month = @kansai_st_insurances_user.where(date: @results.minimum(:date)..@results.maximum(:date))
          @kansai_st_insurances_def_this_month = @kansai_st_insurances_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date)).where(deficiency_solution: nil)

          @kansai_st_insurance_valuation = @kansai_st_insurances_this_month.sum(:valuation) - @kansai_st_insurances_def_this_month.sum(:valuation)
          @kansai_st_insurance_profit = @kansai_st_insurances_this_month.sum(:profit) - @kansai_st_insurances_def_this_month.sum(:profit)
          # 前週
          @kansai_st_insurances_last_week = @kansai_st_insurances_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_st_insurances_def_last_week = @kansai_st_insurances_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days)).where(deficiency_solution: nil)

          @kansai_st_insurance_valuation_last_week = @kansai_st_insurances_last_week.sum(:valuation) - @kansai_st_insurances_def_last_week.sum(:valuation)
          @kansai_st_insurance_profit_last_week = @kansai_st_insurances_last_week.sum(:profit) - @kansai_st_insurances_def_last_week.sum(:profit)
        # 中部キャッシュ合計売上
          # 評価売
          @kansai_cash_sum_valuation = @kansai_dmers_new_valuation + @kansai_dmers_slmt_valuation + @kansai_aupay_new_valuation + @kansai_aupays_slmt_valuation +
            @kansai_paypay_valuation + @kansai_rakuten_pay_valuation + @kansai_st_insurance_valuation
          @kansai_cash_sum_valuation_last_week = @kansai_dmers_new_valuation_last_week + @kansai_dmers_slmt_valuation_last_week +
            @kansai_aupay_new_valuation_last_week + @kansai_aupays_slmt_valuation_last_week + @kansai_paypay_valuation_last_week + @kansai_rakuten_pay_valuation_last_week + @kansai_st_insurance_valuation_last_week
            # 実売
            @kansai_cash_sum_profit = @kansai_dmers_new_profit + @kansai_dmers_slmt_profit + @kansai_aupay_new_profit + @kansai_aupays_slmt_profit + 
              @kansai_paypay_profit + @kansai_rakuten_pay_profit + @kansai_st_insurance_profit
            @kansai_cash_sum_profit_last_week = @kansai_dmers_new_profit_last_week + @kansai_dmers_slmt_profit_last_week +
              @kansai_aupay_new_profit_last_week + @kansai_aupays_slmt_profit_last_week + @kansai_paypay_profit_last_week + @kansai_rakuten_pay_profit_last_week + @kansai_st_insurance_profit_last_week
        # 楽天フェムト新規
          @kansai_rakuten_casas_user = RakutenCasa.includes(:user).where(user: {base: "関西SS"})
          # 今月
          @kansai_rakuten_casas_this_month = @kansai_rakuten_casas_user.where(date: @results.minimum(:date)..@results.maximum(:date))
          @kansai_rakuten_casas_not_this_month = @kansai_rakuten_casas_user.where.not(date: @results.minimum(:date)..@results.maximum(:date))
          @kansai_rakuten_casas_inc = @kansai_rakuten_casas_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
          @kansai_rakuten_casas_dec = @kansai_rakuten_casas_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))

          @kansai_rakuten_casas_def_this_month = @kansai_rakuten_casas_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kansai_rakuten_casas_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))).or(@kansai_rakuten_casas_this_month.where.not(deficiency_net: nil).where(deficiency_solution_net: nil)).or(@kansai_rakuten_casas_this_month.where.not(deficiency_net: nil).where.not(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date))).or(@kansai_rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil)).or(@kansai_rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date)))

          @kansai_rakuten_casa_valuation = @kansai_rakuten_casas_this_month.sum(:valuation_new) - @kansai_rakuten_casas_def_this_month.sum(:valuation_new) +
            @kansai_rakuten_casas_inc.sum(:valuation_new) - @kansai_rakuten_casas_dec.sum(:valuation_new)
          @kansai_rakuten_casa_profit = @kansai_rakuten_casas_this_month.sum(:profit_new) - @kansai_rakuten_casas_def_this_month.sum(:profit_new) +
            @kansai_rakuten_casas_inc.sum(:profit_new) - @kansai_rakuten_casas_dec.sum(:profit_new)
          # 前週
          @kansai_rakuten_casas_last_week = @kansai_rakuten_casas_user.where(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_rakuten_casas_not_last_week = @kansai_rakuten_casas_user.where.not(date: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_rakuten_casas_inc_last_week = @kansai_rakuten_casas_not_last_week.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_rakuten_casas_dec_last_week = @kansai_rakuten_casas_not_last_week.where(deficiency: @results.minimum(:date)..@results.maximum(:date).ago(7.days))

          @kansai_rakuten_casas_def_last_week = @kansai_rakuten_casas_last_week.where.not(deficiency: nil).where(deficiency_solution: nil).or(@kansai_rakuten_casas_last_week.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date).ago(7.days))).or(@kansai_rakuten_casas_last_week.where.not(deficiency_net: nil).where(deficiency_solution_net: nil)).or(@kansai_rakuten_casas_last_week.where.not(deficiency_net: nil).where.not(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date).ago(7.days))).or(@kansai_rakuten_casas_last_week.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil)).or(@kansai_rakuten_casas_last_week.where.not(deficiency_anti: nil).where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date).ago(7.days)))

          @kansai_rakuten_casa_valuation_last_week = @kansai_rakuten_casas_last_week.sum(:valuation_new) - @kansai_rakuten_casas_def_last_week.sum(:valuation_new) + @kansai_rakuten_casas_inc_last_week.sum(:valuation_new) - @kansai_rakuten_casas_dec_last_week.sum(:valuation_new)
          @kansai_rakuten_casa_profit_last_week = @kansai_rakuten_casas_last_week.sum(:profit_new) - @kansai_rakuten_casas_def_last_week.sum(:profit_new) + @kansai_rakuten_casas_inc_last_week.sum(:profit_new) - @kansai_rakuten_casas_dec_last_week.sum(:profit_new)
        # 楽天フェムト設置
          # 今月
          @kansai_rakuten_casa_put = @kansai_rakuten_casas_user.where(put: @results.minimum(:date)..@results.maximum(:date))
          @kansai_rakuten_casa_put_valuation = @kansai_rakuten_casa_put.sum(:valuation_put)
          @kansai_rakuten_casa_put_profit = @kansai_rakuten_casa_put.sum(:profit_put)
          # 前週
          @kansai_rakuten_casas_put_last_week = @kansai_rakuten_casas_user.where(put: @results.minimum(:date)..@results.maximum(:date).ago(7.days))
          @kansai_rakuten_casa_put_valuation_last_week = @kansai_rakuten_casas_put_last_week.sum(:profit_put)
          @kansai_rakuten_casa_put_profit_last_week = @kansai_rakuten_casas_put_last_week.sum(:profit_put)
        # 中部フェムト合計売上
          # 評価売
          @kansai_rakuten_casa_valuation_sum = @kansai_rakuten_casa_valuation + @kansai_rakuten_casa_put_valuation
          @kansai_rakuten_casa_valuation_sum_last_week = @kansai_rakuten_casa_valuation_last_week + @kansai_rakuten_casa_put_valuation_last_week
          # 実売
          @kansai_rakuten_casa_profit_sum = @kansai_rakuten_casa_profit + @kansai_rakuten_casa_put_profit
          @kansai_rakuten_casa_profit_sum_last_week = @kansai_rakuten_casa_profit_last_week + @kansai_rakuten_casa_put_profit_last_week
        # 全拠点合計売上
          @sum_valuation = @chubu_cash_sum_valuation + @chubu_rakuten_casa_valuation_sum +
            @kanto_cash_sum_valuation + @kanto_rakuten_casa_valuation_sum +
            @kansai_cash_sum_valuation + @kansai_rakuten_casa_valuation_sum
          @sum_valuation_last_week = @chubu_cash_sum_valuation_last_week + @chubu_rakuten_casa_valuation_sum_last_week
            @kanto_cash_sum_valuation_last_week + @kanto_rakuten_casa_valuation_sum_last_week
            @kansai_cash_sum_valuation_last_week + @kansai_rakuten_casa_valuation_sum_last_week
          @sum_profit = @chubu_cash_sum_profit + @chubu_rakuten_casa_profit_sum +
            @kanto_cash_sum_profit + @kanto_rakuten_casa_profit_sum +
            @kansai_cash_sum_profit + @kansai_rakuten_casa_profit_sum
          @sum_profit_last_week = @chubu_cash_sum_profit_last_week + @chubu_rakuten_casa_profit_sum_last_week +
            @kanto_cash_sum_profit_last_week + @kanto_rakuten_casa_profit_sum_last_week +
            @kansai_cash_sum_profit_last_week + @kansai_rakuten_casa_profit_sum_last_week
        # 予定シフト数
      elsif @results.group(:user_id).length >= 2 && @results.joins(:user).preload(:user).group(:base).length == 1
        # dメル新規

          @dmers_this_month = this_period(Dmer.all,@results)
          @dmers_not_month = not_period(Dmer.all,@results)
          # @dmers_not_month = Dmer.where.not(date: @results.minimum(:date)..@results.maximum(:date))
          @dmers_inc = @dmers_not_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
          @dmers_dec = @dmers_not_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
          @dmers_def = @dmers_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@dmers_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
      else
      end
        # グラフパラメーター（訪問）
        @all_store = (@results.sum(:cafe_visit) + @results.sum(:other_food_visit) + @results.sum(:cafe_visit) + @results.sum(:other_retail_visit) + @results.sum(:hair_salon_visit) + @results.sum(:other_service_visit)).to_f
      @chart = [
        ["喫茶・カフェ", (@results.sum(:cafe_visit).to_f / @all_store * 100).round(1) ],
        ["その他飲食", (@results.sum(:other_food_visit).to_f / @all_store * 100).round(1) ],
        ["車屋", (@results.sum(:cafe_visit).to_f / @all_store * 100).round(1) ],
        ["その他小売", (@results.sum(:other_retail_visit).to_f / @all_store * 100).round(1) ],
        ["理容・美容", (@results.sum(:hair_salon_visit).to_f / @all_store * 100).round(1) ],
        ["整体・鍼灸", (@results.sum(:manipulative_visit).to_f / @all_store * 100).round(1) ],
        ["その他サービス", (@results.sum(:other_service_visit).to_f / @all_store * 100).round(1) ],
      ]
  end 

  def new 
    @users = User.where.not(position: "退職")
    @result = Result.new 
  end 
  
  def create 
    @users = User.where.not(position: "退職")
    @result = Result.new(result_params)
    if @result.save 
      if @result.shift == "キャッシュレス新規"
        redirect_to  result_result_cashes_new_path(@result.id)
      elsif @result.shift == "楽天フェムト新規"
        redirect_to  result_result_casas_new_path(@result.id)
      elsif @result.shift == "サミット"
        redirect_to  result_result_summits_new_path(@result.id)
      else  
        redirect_to results_path
      end  
    else  
      render :new 
    end
  end

  def show 
    @result = Result.find(params[:id])
    @q = Result.ransack(params[:q])
    @results = 
    if params[:q].nil? 
      Result.none 
    else    
      @q.result(distinct: false)
    end

  end 

  def edit 
    @result = Result.find(params[:id])
  end 
  
  def update 
    @result = Result.find(params[:id])
    @result.update(result_params)
      redirect_to results_path
  end


  private
  # dメル,aupayメソッド
    # 新規
    def this_period(product,date)
      return product.where(date: date.minimum(:date)..date.maximum(:date))
    end
    def not_period(product,date)
      return product.where.not(date: date.minimum(:date)..date.maximum(:date))
    end
    def inc_period(product,date)
      return product.where(deficiency_solution: date.minimum(:date)..date.maximum(:date))
    end
    def dec_period(product,date)
      return product.where(deficiency: date.minimum(:date)..date.maximum(:date))
    end
    def def_period(product,date)
      return product.where.not(deficiency: nil).where(deficiency_solution: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution: date.minimum(:date)..date.maximum(:date)))
    end
    # 決済
    def slmt_this_period(product,date)
      return product.where(settlement: date.minimum(:date)..date.maximum(:date))
    end
    def slmt_not_period(product,date)
      return product.where.not(settlement: date.minimum(:date)..date.maximum(:date))
    end
    def slmt_inc_period(product,date)
      return product.where(deficiency_solution_settlement: date.minimum(:date)..date.maximum(:date))
    end
    def slmt_dec_period(product,date)
      return product.where(deficiency_settlement: date.minimum(:date)..date.maximum(:date))
    end
    def slmt_def_period(product,date)
      return product.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(product.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: date.minimum(:date)..date.maximum(:date)))
    end
    
    def cash_period(product, date)
      if date.minimum(:date).month != 1
        cash_from = Date.new(date.minimum(:date).year,date.minimum(:date).month - 1,26)
        cash_to = Date.new(date.minimum(:date).year,date.minimum(:date).month,25)
      else  
        cash_from = Date.new(date.minimum(:date).year,12,26)
        cash_to = Date.new(date.minimum(:date).year,date.minimum(:date).month,25)
      end
      return product.where(date: cash_from..cash_to)
    end

  def result_params
    params.require(:result).permit(
      :user_id,
      :date,
      :profit,
      :area,
      :shift,
      :ojt_id, 
    # 基準値
      # 前半
      :first_visit,
      :first_interview,
      :first_full_talk, 
      :first_get,       
      # 後半 
      :latter_visit,     
      :latter_interview, 
      :latter_full_talk, 
      :latter_get,       
    # 店舗別基準値
      # 喫茶・カフェ
      :cafe_visit,          
      :cafe_get,            
      # その他・飲食
      :other_food_visit,             
      :other_food_get       ,     
      # 車屋
      :car_visit          ,
      :car_get            ,
      # その他小売
      :other_retail_visit  ,        
      :other_retail_get            ,
      # 美容・理容
      :hair_salon_visit          ,
      :hair_salon_get            ,
      # 整体・鍼灸
      :manipulative_visit         , 
      :manipulative_get            ,
      # その他・サービス
      :other_service_visit          ,
      :other_service_get    ,
    )
  end 
end
