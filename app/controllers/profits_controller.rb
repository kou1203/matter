class ProfitsController < ApplicationController
  def index
# 期間
  @month = params[:month] ? Time.parse(params[:month]) : Date.today
  @start_date = @month.prev_month.beginning_of_month.since(25.days) # 26日
  @end_date = @month.beginning_of_month.since(24.days) # 25日
  @start_done = @month.beginning_of_month # 月初
  @end_done = @month.end_of_month # 月末
  @rakuten_start = @month.prev_month.beginning_of_month.since(10.days) # 11日
  @rakuten_end = @month.beginning_of_month.since(14.days) # 15日
  @rakuten_change_date = @month.beginning_of_month.since(17.days) # 18日
  @results = 
    Result.includes(:user).where(shift: "キャッシュレス新規").where(date: @start_date..@end_date)
    .or(
      Result.includes(:user).where(shift: "キャッシュレス決済").where(date: @start_date..@end_date)
    )
  @shifts = 
    Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
    .or(
      Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス決済")
    )

# ハッシュ・リストデータ
  @chubu_cash_list = []
  @kansai_cash_list = []
  @kanto_cash_list = []
  @partner_cash_list = []
  @femto_list = []
  @summit_list = []
  @retire_list = []
  @all_list = []
  @bases = ["中部SS", "関西SS", "関東SS", "2次店","退職"]
  @users = 
    User.where(base_sub: "キャッシュレス")
    .or(
      User.where(base_sub: "フェムト")
    )
    .or(
      User.where(base_sub: "サミット")
    )
  # ハッシュの中身
    @bases.each do |base| # 拠点ごとに繰り返す
      @users.where(base: base).each do |user| #ユーザーごとに繰り返す
        person_hash = {}
      # ユーザー情報
        user_result = @results.where(user_id: user.id)
        if user.position == "退職"
          person_hash["拠点"] = "その他"
        elsif user.base_sub == "フェムト"
          person_hash["拠点"] = "フェムト"
        elsif user.base_sub == "サミット"
          person_hash["拠点"] = "サミット"
        else  
          person_hash["拠点"] = user.base 
        end
        person_hash["名前"] = user.name
        person_hash["役職"] = user.position_sub
      # 予定シフト
        user_shift = @shifts.where(user_id: user.id)
        person_hash["予定シフト"] = user_shift.length
        person_hash["予定新規シフト"] = user_shift.where(shift: "キャッシュレス新規").length
        person_hash["予定決済シフト"] = user_shift.where(shift: "キャッシュレス決済").length
        person_hash["予定決済シフト"] = user_shift.where(shift: "キャッシュレス決済").length
        user_shift26_10 = user_shift.where(shift: "キャッシュレス新規").where(start_time: @start_date..@end_date.beginning_of_month.since(9.days)).length
      # 消化シフト
        user_result_shift = 
          user_result.where(shift: "キャッシュレス新規")
            .or(
              user_result.where(shift: "キャッシュレス決済")
            )
        person_hash["消化シフト"] = user_result_shift.length 
        person_hash["消化新規シフト"] = user_result_shift.where(shift: "キャッシュレス新規").length 
        person_hash["消化決済シフト"] = user_result_shift.where(shift: "キャッシュレス決済").length 
        user_result26_10 = user_result_shift.where(shift: "キャッシュレス新規").where(date: @start_date..@end_date.beginning_of_month.since(9.days)).length
      # 基準値
        person_hash["訪問"] = user_result.sum("first_total_visit + latter_total_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["応答"] = user_result.sum("first_visit + latter_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["対面"] = user_result.sum("first_interview + latter_interview") / person_hash["消化新規シフト"] rescue 0
        person_hash["フル"] = user_result.sum("first_full_talk + latter_full_talk") / person_hash["消化新規シフト"] rescue 0
        person_hash["獲得"] = user_result.sum("first_get + latter_get") / person_hash["消化新規シフト"] rescue 0
      # 単価
        # 単価
        dmer_price_1 = 9000
        dmer_price_2 = 5000
        dmer_price_3 = 5000
        aupay_price = 13500
        paypay_price = 2000
        # 審査通過率
        if (Date.today > @end_date) && (Date.today.month == @end_date.month)
          dec_per = (Date.today.day - @end_date.day) * 0.1
        else  
          dec_per = 0
        end
        dmer_result1_per = 0.64
        dmer_result2_per = 0.58
        dmer_result3_per = 0.52
        dmer_result1_per_prev = 0.9
        dmer_result2_per_prev = 0.9
        dmer_result3_per_prev = 1
        dmer_this_month_slmt_per = 0.6
        dmer_prev_month_slmt_per = 0.9
        aupay_slmt_per = 0.75
        aupay_slmt_per_prev = 0.71
        # dメル
        if dec_per > dmer_result1_per 
          dmer_result1_per = 0 
        else 
          dmer_result1_per = dmer_result1_per - dec_per 
        end 
        
        if dec_per > dmer_result2_per 
          dmer_result2_per = 0 
        else 
          dmer_result2_per = dmer_result2_per - dec_per 
        end 
        
        if dec_per > dmer_result3_per 
          dmer_result3_per = 0 
        else 
          dmer_result3_per = dmer_result3_per - dec_per 
        end 
        
        if dec_per > dmer_result1_per_prev 
          dmer_result1_per_prev = 0 
        else 
          dmer_result1_per_prev = dmer_result1_per_prev - dec_per 
        end 
        
        if dec_per > dmer_result2_per_prev 
          dmer_result2_per_prev = 0 
        else 
          dmer_result2_per_prev = dmer_result2_per_prev - dec_per 
        end 
        # auPay
        if dec_per > aupay_slmt_per 
          aupay_slmt_per = 0 
        else 
          aupay_slmt_per = aupay_slmt_per - dec_per 
        end 
        if dec_per > aupay_slmt_per_prev
          aupay_slmt_per_prev = 0 
        else 
          aupay_slmt_per_prev = aupay_slmt_per_prev - dec_per 
        end 
      # dメル
        dmer_user = 
          Dmer.where(user_id: user.id).includes(:store_prop)
        dmer_slmter = 
          Dmer.where(settlementer_id: user.id)
        # 現状売上
          # 第一成果
          dmer_result1 = 
            dmer_user.where(result_point: @start_done..@end_done)
            .where("? >= settlement", @end_done)
            .where(status: "審査OK")
            .where.not(industry_status: "NG")
            .where.not(industry_status: "×")
            .where.not(industry_status: "要確認")
            .or(
              dmer_user.where(settlement: @start_done..@end_done)
              .where("? >= result_point", @end_done)
              .where(status: "審査OK")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "×")
              .where.not(industry_status: "要確認")
            )
          dmer_result1_profit = dmer_result1.sum(:profit_new)
          person_hash["dメル第一成果件数"] = dmer_result1.length
          person_hash["dメル現状売上1"] = dmer_result1_profit
          # 第二成果
          dmer_result2 = 
            dmer_slmter.where(status_update_settlement: @start_done..@end_done)
            .where(status: "審査OK")
            .where.not(industry_status: "NG")
            .where.not(industry_status: "×")
            .where.not(industry_status: "要確認")
            .where(status_settlement: "完了")

            dmer_result2_profit = dmer_result2.sum(:profit_settlement)
          person_hash["dメル第二成果件数"] = dmer_result2.length
          person_hash["dメル現状売上2"] = dmer_result2_profit
          # 第三成果
          dmer_result3 = 
            dmer_slmter.where(settlement_second: @start_done..@end_done)
            .where("? >= status_update_settlement", @end_done)
            .where(status: "審査OK")
            .where.not(industry_status: "NG")
            .where.not(industry_status: "×")
            .where.not(industry_status: "要確認")
            .where(status_settlement: "完了")
            .or(
              dmer_slmter
              .where(status_update_settlement: @start_done..@end_done)
              .where("? >= settlement_second", @end_done)
              .where(status: "審査OK")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "×")
              .where.not(industry_status: "要確認")
              .where(status_settlement: "完了")
            )
          dmer_result3_profit = dmer_result3.sum(:profit_second_settlement)
          person_hash["dメル第三成果件数"] = dmer_result3.length
          person_hash["dメル現状売上3"] = dmer_result3_profit
        
        # 獲得数
          dmer_uq = dmer_user.where(date: @start_date..@end_date).where(store_prop: {head_store: nil})
          dmer_def =  dmer_uq.where(status: "自社不備")
          .or(dmer_uq.where(status: "審査NG"))
          .or(dmer_uq.where(status: "申込取消"))
          .or(dmer_uq.where(status: "申込取消（不備）"))
          .or(dmer_uq.where(status: "社内確認中"))
          .or(dmer_uq.where(status: "審査OK").where(industry_status: "NG"))
          .or(dmer_uq.where(status: "審査OK").where(industry_status: "×"))
          .or(dmer_uq.where(status: "不備対応中"))
          dmer_db = 
          dmer_user.where(share: @start_date..@end_date).where.not(store_prop: {head_store: nil})
          .where.not(industry_status: "×").where.not(industry_status: "NG").where.not(industry_status: "要確認")
          .where.not(status: "不備対応中")
          .where.not(status: "審査NG")
          .where.not(status: "本店審査待ち")
          dmer_len = dmer_uq.length  - dmer_def.length + dmer_db.length #評価件数
          dmer_slmt2nd = dmer_slmter.where(settlement_second: @start_done..@end_done)
          if dmer_len == 0
            dmer_len_ave = 0
          else
            dmer_len_ave = (dmer_len.to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          end 
        # 評価件数
          dmer_val1_period =  
          dmer_user.where(status: "審査OK")
          .where.not(industry_status: "×")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "要確認")
          .where(date: @start_date..@end_date)
          dmer_val1_period = 
            dmer_val1_period.where(result_point: @start_date..@end_done)
            .where("? >= settlement",@end_done)
            .or(
              dmer_val1_period.where(settlement: @start_date..@end_done)
              .where("? >= result_point",@end_done)
            )
            
          dmer_val2_period = 
          dmer_user.where(status: "審査OK")
          .where.not(industry_status: "×")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "要確認")
          .where(date: @start_date..@end_date)
          .where("? >= status_update_settlement",@end_done)
          .where(status_settlement: "完了")
          dmer_val3_period = dmer_val2_period.where.not(settlement_second: nil)
          dmer_val1_period_len = dmer_val1_period.length
          dmer_val2_period_len = dmer_val2_period.length
          dmer_val3_period_len = dmer_val3_period.length
        # 過去月の決済対象
          dmer_slmt_tgt_prev = 
            dmer_user.where("settlement_deadline >= ?", @start_date)
            .where("? > date", @start_date)
            .where(status: "審査OK")
            .where.not(industry_status: "×")
            .where.not(industry_status: "NG")
            .where.not(industry_status: "要確認")
            .where(status_update_settlement: nil)
            .or(
              dmer_user.where("settlement_deadline >= ?", @start_date)
              .where("? > date", @start_date)
              .where(status: "審査OK")
              .where(status_settlement: "完了")
              .where.not(industry_status: "×")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "要確認")
              .where(status_update_settlement: @start_done..@end_done)
            )
            dmer_slmt_tgt_prev_len = dmer_slmt_tgt_prev.length rescue 0
            # 決済期限切れ
            dmer_slmt_dead = 
              dmer_slmt_tgt_prev.where(status_settlement: "期限切れ")
              .where(status_update_settlement: nil)
            dmer_slmt_dead_len = dmer_slmt_dead.length
            # 過去の案件で対象月に成果になったもの
            dmer_slmt_prev_val =  
              dmer_slmt_tgt_prev.where(status_update_settlement: @start_done..@end_done)
            dmer_2ndslmt_prev_val = 
              dmer_slmt_prev_val.where("? >= settlement_second", @month.next_month.end_of_month)
            dmer_slmt_prev_val_len = dmer_slmt_prev_val.length
            dmer_2ndslmt_prev_val_len = dmer_2ndslmt_prev_val.length
        # 終着
          # 第一成果
            # 期間内
            dmer_result1_fin_this_month_len = 
            (
              (dmer_len - dmer_val1_period_len).to_f / person_hash["消化新規シフト"] * person_hash["予定新規シフト"] * dmer_result1_per
            ).round() rescue 0 
            dmer_result1_fin_this_month = 
            (dmer_price_1 * dmer_result1_fin_this_month_len) + dmer_result1.where(date: @start_date..@end_date).sum(:profit_new)
            # 過去月
            dmer_result1_fin_prev_month_len =
            (
              (dmer_slmt_tgt_prev.length - dmer_slmt_prev_val_len).to_f * dmer_result1_per_prev
            ).round()
            dmer_result1_fin_prev_month = 
              (dmer_price_1 * dmer_result1_fin_prev_month_len) + 
              dmer_result1.where("? > date",@start_date).sum(:profit_new)
            # 合計
            dmer_result1_fin = dmer_result1_fin_this_month + dmer_result1_fin_prev_month
            # person_hash["dメル一次成果終着（期間内）"] = dmer_result1.where("? > date",@start_date).sum(:profit_new)
            # person_hash["dメル一次成果終着（過去月）"] = dmer_result1_fin_prev_month_len
            person_hash["dメル一次成果終着"] = dmer_result1_fin
          # 第二成果
            # 期間内
            dmer_result2_fin_this_month_len =
            (
              (dmer_len - dmer_val2_period_len).to_f / person_hash["消化新規シフト"] * person_hash["予定新規シフト"] * dmer_result2_per
            ).round() rescue 0
            dmer_result2_fin_this_month = 
            (dmer_price_2 * dmer_result2_fin_this_month_len) + 
            dmer_result2.where(date: @start_date..@end_date).sum(:profit_settlement)
            # 過去月
            dmer_result2_fin_prev_month = 
            (dmer_price_2 * dmer_result1_fin_prev_month_len) + 
            dmer_result2.where("? > date",@start_date).sum(:profit_settlement)
            # 合計
            dmer_result2_fin = dmer_result2_fin_this_month + dmer_result2_fin_prev_month
            person_hash["dメル二次成果終着（期間内）"] = dmer_result2_fin_this_month
            person_hash["dメル二次成果終着（過去）"] = dmer_result2_fin_prev_month
            person_hash["dメル二次成果終着"] = dmer_result2_fin
          # 第三成果
            dmer_result3 = 
              dmer_slmter.where(settlement_second: @start_done..@end_done)
              .where.not(industry_status: "NG")
              .where.not(industry_status: "×")
              .where.not(industry_status: "要確認")
              .where(status: "審査OK")
              .where(status_settlement: "完了")
              .where("? >= status_update_settlement", @end_done)
              .or(
                dmer_slmter.where(status_update_settlement: @start_done..@end_done)
                .where.not(industry_status: "NG")
                .where.not(industry_status: "×")
                .where.not(industry_status: "要確認")
                .where(status: "審査OK")
                .where(status_settlement: "完了")
                .where("? >= settlement_second", @end_done)
              )
            dmer_slmt2nd_profits = dmer_result3.sum(:profit_second_settlement)
            dmer_result3_len = dmer_result3.length
            dmer_slmt2nd_len = dmer_slmt2nd.length
            # 期間内
            dmer_result3_fin_this_month_len = 
                  (
                    (dmer_len - dmer_val3_period_len).to_f / 
                    person_hash["消化新規シフト"] * person_hash["予定新規シフト"] * dmer_result3_per
                  ).round() rescue 0 
            dmer_result3_fin_this_month = 
              (dmer_price_3 * dmer_result3_fin_this_month_len) + 
              dmer_result3.where(date: @start_date..@end_date).sum(:profit_second_settlement)  
            dmer_result3_fin_prev_month = 
              (
                dmer_price_3 * (dmer_slmt_tgt_prev_len - dmer_2ndslmt_prev_val_len - dmer_slmt_dead_len)
              ) + (dmer_result3.where("? > date",@start_date).sum(:profit_second_settlement))
            dmer_result3_fin = dmer_result3_fin_this_month + dmer_result3_fin_prev_month
            # person_hash["dメル三次成果終着（期間内）"] = dmer_result3_fin_this_month
            # person_hash["dメル三次成果終着（過去月）"] = dmer_result3_fin_prev_month
            person_hash["dメル三次成果終着"] = dmer_result3_fin
      # auPay
        aupay_user = Aupay.includes(:store_prop).where(user_id: user.id)
        aupay_slmter = 
          Aupay.where(settlementer_id: user.id)
        # 獲得数（26-10日）
          aupay_uq_26_10 = aupay_user.where(date: @start_date..@end_date.beginning_of_month.since(9.days)) 
          aupay_val_26_10 = 
            aupay_uq_26_10.where(status: "審査通過")
            .where(status_settlement: "完了")
            .where(status_update_settlement: @start_done..@end_done)
          aupay_def_26_10 = 
            aupay_uq_26_10.where(status: "不合格")
            .or(aupay_uq_26_10.where(status: "申込取消"))
            .or(aupay_uq_26_10.where(status: "差し戻し"))
            .or(aupay_uq_26_10.where(status: "報酬対象外"))
            .or(aupay_uq_26_10.where(status: "重複対象外"))
            .or(aupay_uq_26_10.where(status: "本店審査待ち"))
            .or(aupay_uq_26_10.where(status: "自社NG"))
            .or(aupay_uq_26_10.where(status: "自社不備"))
            .or(aupay_uq_26_10.where(status: "解約"))
            aupay_uq_26_10_len = aupay_uq_26_10.length
            aupay_def_26_10_len = aupay_def_26_10.length
            aupay_val_26_10_len = aupay_val_26_10.length
        # 過去の決済対象
          aupay_slmt_tgt_prev = 
            aupay_user.where("settlement_deadline >= ?", @start_date)
            .where("? > date", @start_date)
            .where(status: "審査通過")
            .where(status_update_settlement: nil)
            .or(
              aupay_user.where("settlement_deadline >= ?", @start_date)
              .where("? > date", @start_date)
              .where(status: "審査通過")
              .where(status_update_settlement: @start_done..@end_done)
            )
          aupay_slmt_tgt_prev_len = aupay_slmt_tgt_prev.length
          aupay_slmt_prev_val = 
          aupay_slmt_tgt_prev.where(status_update_settlement: @start_done..@end_done)
          aupay_slmt_prev_val_len = aupay_slmt_prev_val.length
        # 現状売上
          # 一次成果
            aupay_result1 = 
              aupay_slmter.where(status_update_settlement: @start_done..@end_done)
              .where(status: "審査通過")
              .where(status_settlement: "完了")
            aupay_result1_profit = aupay_result1.sum(:profit_settlement)
            person_hash["auPay第一成果件数"] = aupay_result1.length
            person_hash["auPay現状売上1"] = aupay_result1_profit
        # 終着
          # 一次成果
            # 期間内
            aupay_result1_fin_len = 
              (
                (aupay_uq_26_10_len - aupay_def_26_10_len - aupay_val_26_10_len).to_f / 
                user_shift26_10 * user_result26_10 * aupay_slmt_per
              ).round() rescue 0 
            aupay_result1_fin_this_month = 
              (aupay_price * aupay_result1_fin_len) + 
              aupay_result1.where(date: @start_date..@end_date).sum(:profit_settlement) rescue 0
            # 過去月
            aupay_result1_fin_prev_month_len = 
              (
                (aupay_slmt_tgt_prev_len - aupay_slmt_prev_val_len) * aupay_slmt_per_prev
              ).round() rescue 0
            aupay_result1_fin_prev_month = 
              (aupay_price * aupay_result1_fin_prev_month_len) + 
              aupay_result1.where("? > date", @start_date).sum(:profit_settlement) rescue 0
            aupay_result1_fin = aupay_result1_fin_this_month + aupay_result1_fin_prev_month
            # person_hash["auPay一次成果終着（期間内）"] = aupay_def_26_10_len
            # person_hash["auPay一次成果終着（過去月）"] = aupay_result1_fin_prev_month
            person_hash["auPay一次成果終着"] = aupay_result1_fin
      #PayPay
        paypay_user = Paypay.where(user_id: user.id)
        # 現状売上
          # 一次成果
          paypay_result1 = paypay_user.where(status: "60審査可決").where(result_point: @start_done..@end_done)
          paypay_result1_profit = paypay_result1.sum(:profit)
          person_hash["PayPay第一成果件数"] = paypay_result1.length
          person_hash["PayPay現状売上"] = paypay_result1_profit
        # 終着売上
          # 一次成果
          paypay_data = paypay_user.where(date: @start_date..@end_date)
          paypay_len = paypay_data.length
          if paypay_len == 0
            paypay_len_ave = 0
          else 
            paypay_len_ave = (paypay_len.to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          end 
          paypay_fin_len = (paypay_len_ave * person_hash["予定新規シフト"]).round() rescue 0 
          paypay_result1_fin = paypay_price * paypay_fin_len rescue 0
          if (paypay_result1_profit > paypay_result1_fin) || (Date.today >=@end_done)
            paypay_result1_fin = paypay_result1_profit
          end 
          person_hash["PayPay一次成果終着"] = paypay_result1_fin
      # 楽天ペイ
        rakuten_pay_user = RakutenPay.where(user_id: user.id).where(status: "OK")
        # 一次成果
        rakuten_pay_result1 = rakuten_pay_user.where(result_point: @rakuten_start..@rakuten_end)
        rakuten_pay_result1_len = rakuten_pay_result1.length 
        rakuten_pay_result1_profit = rakuten_pay_result1.sum(:profit)
        person_hash["楽天ペイ第一成果件数"] = rakuten_pay_result1.length
        person_hash["楽天ペイ現状売上"] = rakuten_pay_result1_profit
        # 終着売上
        rakuten_pay_result1_prev = rakuten_pay_user.where(result_point: @rakuten_start.prev_month..@rakuten_end.prev_month)
        rakuten_pay_result1_prev_len = rakuten_pay_result1_prev.length
        rakuten_pay_result1_prev_profit = rakuten_pay_result1_prev.sum(:profit)
        if (rakuten_pay_result1_len >= rakuten_pay_result1_prev_len) || (Date.today >= @rakuten_change_date)
          rakuten_pay_result1_prev_profit = rakuten_pay_result1_profit
        end 
        person_hash["楽天ペイ一次成果終着"] = rakuten_pay_result1_prev_profit
      # AirPay
        airpay_all = 
          Airpay.where(date: @start_date..@end_date).where(status: "審査完了")
          .or(
            Airpay.where(date: @start_date..@end_date).where(status: "審査中")
          )
          airpay_all_len = airpay_all.length
          airpay_all_len_ave = (airpay_all_len.to_f / @results.where(shift: "キャッシュレス新規").length).round(1)
          airpay_all_len_fin = (airpay_all_len_ave * @shifts.where(shift: "キャッシュレス新規").length * 0.85).round() rescue 0
          airpay_user = airpay_all.where(user_id: user.id)
          airpay_user_len = airpay_user.length
          airpay_len_ave = (airpay_user_len.to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          airpay_len_fin = (airpay_len_ave * person_hash["予定新規シフト"] * 0.85).round() rescue 0
        # 単価
        airpay_price = 
          if airpay_all_len_fin >= 300
            15000
          elsif airpay_all_len_fin >= 75
            11000
          else  
            3000
          end 
        # 一次成果
        airpay_user = 
          Airpay.where(user_id: user.id).where(status: "審査完了")
        airpay_result1 = airpay_user.where(result_point: @start_done..@end_done)
        airpay_result1_profit = airpay_result1.sum(:profit) + (airpay_result1.length * (airpay_price - 3000) )
        person_hash["AirPay第一成果件数"] = airpay_result1.length
        person_hash["AirPay現状売上"] = airpay_result1_profit
        # 終着
        airpay_result1_fin = airpay_price * airpay_len_fin rescue 0
        if (airpay_result1_profit >= airpay_result1_fin) || (Date.today >= @end_done)
          airpay_result1_fin = airpay_result1_profit
        end 
        person_hash["AirPay獲得数"] = airpay_len_ave
        person_hash["AirPay一次成果終着"] = airpay_result1_fin
      # 出前館
        demaekan_user = Demaekan.where(user_id: user.id).where(status: "完了")
        # 一次成果
        demaekan_result1 = demaekan_user.where(first_cs_contract: @start_date..@end_date)
        demaekan_result1_profit = demaekan_result1.sum(:profit)
        person_hash["出前館第一成果件数"] = demaekan_result1.length
        person_hash["出前館現状売上"] = demaekan_result1_profit
        person_hash["出前館一次成果終着"] = demaekan_result1_profit
      # auステッカー
          au_sticker_user = OtherProduct.where(user_id: user.id).where(product_name: "auPay写真")
          au_sticker_result1 = au_sticker_user.where(date: @start_done.. @end_done)
          au_sticker_result1_profit = au_sticker_result1.sum(:profit)
          person_hash["auステッカー第一成果件数"] = au_sticker_result1.length
          person_hash["auステッカー現状売上"] = au_sticker_result1_profit
          person_hash["auステッカー一次成果終着"] = au_sticker_result1_profit
      # 現状売上
          # 新規
          profit_new = 
            person_hash["dメル現状売上1"] + person_hash["PayPay現状売上"] + person_hash["楽天ペイ現状売上"] +
            person_hash["AirPay現状売上"] + person_hash["出前館現状売上"] + person_hash["auステッカー現状売上"]
          person_hash["新規現状売上"] = profit_new
          # 決済
          profit_slmt = 
            person_hash["dメル現状売上2"] + person_hash["dメル現状売上3"] + person_hash["auPay現状売上1"]
          person_hash["決済現状売上"] = profit_slmt
          # 合計
            person_hash["合計現状売上"] = profit_new + profit_slmt
      # 終着売上
          # 新規
          profit_new_fin = 
            person_hash["dメル一次成果終着"] + person_hash["PayPay一次成果終着"] + person_hash["楽天ペイ一次成果終着"] +
            person_hash["AirPay一次成果終着"] + person_hash["出前館一次成果終着"] + person_hash["auステッカー一次成果終着"]
          person_hash["新規終着"] = profit_new_fin
          # 決済
          profit_slmt_fin = 
            person_hash["dメル二次成果終着"] + person_hash["dメル三次成果終着"] + person_hash["auPay一次成果終着"]
          person_hash["決済終着"] = profit_slmt_fin
          # 合計
            person_hash["合計終着"] = profit_new_fin + profit_slmt_fin

      # ハッシュへデータを配列へ格納
        @all_list << person_hash
        if (user.base_sub =="フェムト") && (user.position != "退職")
          @femto_list << person_hash
        elsif (user.base_sub =="サミット") && (user.position != "退職")
          @summit_list << person_hash
        elsif (base == "中部SS") && (user.position != "退職")
          @chubu_cash_list << person_hash
        elsif (base == "関西SS") && (user.position != "退職")
          @kansai_cash_list << person_hash
        elsif (base == "関東SS") && (user.position != "退職")
          @kanto_cash_list << person_hash
        elsif (base == "2次店") && (user.position != "退職")
          @partner_cash_list << person_hash
        elsif (user.position == "退職")
          @retire_list << person_hash
        end 
      end #ユーザーごとに繰り返す
    end # 拠点ごとに繰り返す
  @base_list = [@chubu_cash_list,@kansai_cash_list,@kanto_cash_list,@femto_list,@summit_list,@partner_cash_list,@retire_list]
  end 
end