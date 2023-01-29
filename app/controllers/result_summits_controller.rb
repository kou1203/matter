class ResultSummitsController < ApplicationController


  def new 
    @result = Result.find(params[:result_id])
    @result_summit = ResultSummit.new 
  end 
  
  def create 
    @result = Result.find(params[:result_id])
    @result_summit = ResultSummit.new(result_summit_params)
    if @result_summit.save 
      redirect_to result_summit_path(@result_summit.result.user_id)
    else  
      render :new 
    end
  end

  def show 
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    @start_date = @month.beginning_of_month
    @end_date = @month.end_of_month
    @date_period = (@start_date..@end_date)
    @user = User.find(params[:id])
    @summits = Summit.where(user_id: @user.id).where(date: @start_date..@end_date)
    @results = Result.includes(:result_summit).where(user_id: @user.id).where(date: @start_date..@end_date)
    @result_summit = 
      @results.where(shift: "電気")
      .or(
        @results.where(shift: "設置電気")
      )
    @result_ojt = @results.where(shift: "帯同")
    @result_office_work = @results.where(shift: "内勤")
    @shifts = Shift.where(user_id: @user.id).where(start_time: @start_date..@end_date)
    @shift_summit = 
      @shifts.where(shift: "電気")
      .or(
        @shifts.where(shift: "設置電気")

      )
    @shift_summit_only = @shift_summit.where(shift: "電気")
    @shift_summit_and_put = @shift_summit.where(shift: "設置電気")
    @shift_ojt = @shifts.where(shift: "帯同")
    @shift_office_work = @shifts.where(shift: "内勤")


    @result_summit_only_data = ""  
    @result_summit_and_put_data = ""
    @result_summit_only = @results.where(shift: "電気")
    @result_summit_and_put = @results.where(shift: "設置電気")
    @summit_ary = [@result_summit_only, @result_summit_and_put]
    @summit_ary.each do |summit|
      person_hash = {}
      # 合計
      person_hash["消化シフト数"] = summit.length
      person_hash["合計訪問"] = summit.sum(:first_visit) +  summit.sum(:latter_visit) 
      person_hash["合計対面"] = summit.sum(:first_interview) +  summit.sum(:latter_interview) 
      person_hash["合計フル①"] = summit.sum(:first_full_talk) +  summit.sum(:latter_full_talk) 
      person_hash["合計フル②"] = summit.sum(:first_full_talk2) +  summit.sum(:latter_full_talk2) 
      person_hash["合計成約"] = summit.sum(:first_get) +  summit.sum(:latter_get) 
      person_hash["フル（再訪）"] = summit.sum(:revisit_full_talk)
      person_hash["成約（再訪）"] = summit.sum(:revisit_get)
      # 前半
      person_hash["前半訪問"] = summit.sum(:first_visit)
      person_hash["前半対面"] = summit.sum(:first_interview)
      person_hash["前半フル①"] = summit.sum(:first_full_talk)
      person_hash["前半フル②"] = summit.sum(:first_full_talk2)
      person_hash["前半成約"] = summit.sum(:first_get)
      # 後半
      person_hash["後半訪問"] = summit.sum(:latter_visit)
      person_hash["後半対面"] = summit.sum(:latter_interview)
      person_hash["後半フル①"] = summit.sum(:latter_full_talk)
      person_hash["後半フル②"] = summit.sum(:latter_full_talk2)
      person_hash["後半成約"] = summit.sum(:latter_get)
      # 電力会社
      person_hash["地域電力フル①"] = summit.sum(:power_company1_full_talk1) 
      person_hash["地域電力フル②"] = summit.sum(:power_company1_full_talk2) 
      person_hash["地域電力成約"] = summit.sum(:power_company1_get) 
      person_hash["地域ガスフル①"] = summit.sum(:power_company2_full_talk1) 
      person_hash["地域ガスフル②"] = summit.sum(:power_company2_full_talk2) 
      person_hash["地域ガス成約"] = summit.sum(:power_company2_get) 
      person_hash["ハルエネフル①"] = summit.sum(:power_company3_full_talk1) 
      person_hash["ハルエネフル②"] = summit.sum(:power_company3_full_talk2) 
      person_hash["ハルエネ成約"] = summit.sum(:power_company3_get) 
      person_hash["その他フル①"] = summit.sum(:power_company4_full_talk1) 
      person_hash["その他フル②"] = summit.sum(:power_company4_full_talk2) 
      person_hash["その他成約"] = summit.sum(:power_company4_get) 
      # 業種基準値
      person_hash["飲食訪問"] = summit.sum(:industry1_visit) 
      person_hash["飲食成約"] = summit.sum(:industry1_get) 
      person_hash["小売訪問"] = summit.sum(:industry2_visit) 
      person_hash["小売成約"] = summit.sum(:industry2_get) 
      person_hash["サービス訪問"] = summit.sum(:industry3_visit) 
      person_hash["サービス成約"] = summit.sum(:industry3_get) 
      # フルトーク①
      person_hash["何故見せないと対面"] = summit.sum(:out_interview_01) 
      person_hash["何故見せないとフル"] = summit.sum(:out_full_talk_01) 
      person_hash["何故見せないと成約"] = summit.sum(:out_get_01) 
      person_hash["君は誰対面"] = summit.sum(:out_interview_02) 
      person_hash["君は誰フル"] = summit.sum(:out_full_talk_02) 
      person_hash["君は誰成約"] = summit.sum(:out_get_02) 
      person_hash["明細ない対面"] = summit.sum(:out_interview_03) 
      person_hash["明細ないフル"] = summit.sum(:out_full_talk_03) 
      person_hash["明細ない成約"] = summit.sum(:out_get_03) 
      person_hash["探したが無い対面"] = summit.sum(:out_interview_04) 
      person_hash["探したが無いフル"] = summit.sum(:out_full_talk_04) 
      person_hash["探したが無い成約"] = summit.sum(:out_get_04) 
      person_hash["忙しい対面"] = summit.sum(:out_interview_05) 
      person_hash["忙しいフル"] = summit.sum(:out_full_talk_05) 
      person_hash["忙しい成約"] = summit.sum(:out_get_05) 
      person_hash["電気断ってる対面"] = summit.sum(:out_interview_06) 
      person_hash["電気断ってるフル"] = summit.sum(:out_full_talk_06) 
      person_hash["電気断ってる成約"] = summit.sum(:out_get_06)
      person_hash["ペロ対面"] = summit.sum(:out_interview_07) 
      person_hash["ペロフル"] = summit.sum(:out_full_talk_07) 
      person_hash["ペロ成約"] = summit.sum(:out_get_07)
      # フルトーク②
      person_hash["フル②口座拒否フル"] = summit.sum(:out2_full_talk_01) 
      person_hash["フル②口座拒否成約"] = summit.sum(:out2_get_01) 
      person_hash["フル②クレがいいフル"] = summit.sum(:out2_full_talk_02)
      person_hash["フル②クレがいい成約"] = summit.sum(:out2_get_02) 
      person_hash["フル②忙しいフル"] = summit.sum(:out2_full_talk_03) 
      person_hash["フル②忙しい成約"] = summit.sum(:out2_get_03) 
      person_hash["フル②怪しいフル"] = summit.sum(:out2_full_talk_04) 
      person_hash["フル②怪しい成約"] = summit.sum(:out2_get_04) 
      person_hash["フル②検討するフル"] = summit.sum(:out2_full_talk_05) 
      person_hash["フル②検討する成約"] = summit.sum(:out2_get_05) 
      person_hash["フル②既存のままフル"] = summit.sum(:out2_full_talk_06) 
      person_hash["フル②既存のまま成約"] = summit.sum(:out2_get_06)
      person_hash["フル②メアドなしフル"] = summit.sum(:out2_full_talk_07) 
      person_hash["フル②メアドなし成約"] = summit.sum(:out2_get_07)
      person_hash["フル②確認書なしフル"] = summit.sum(:out2_full_talk_08) 
      person_hash["フル②確認書なし成約"] = summit.sum(:out2_get_08)
      person_hash["フル②口座印なしフル"] = summit.sum(:out2_full_talk_09) 
      person_hash["フル②口座印なし成約"] = summit.sum(:out2_get_09)
      person_hash["フル②解約金フル"] = summit.sum(:out2_full_talk_10) 
      person_hash["フル②解約金成約"] = summit.sum(:out2_get_10)
      person_hash["フル②ペロフル"] = summit.sum(:out2_full_talk_11) 
      person_hash["フル②ペロ成約"] = summit.sum(:out2_get_11)
      if summit.present?
        if summit.first.shift == "電気" 
          @result_summit_only_data = person_hash
        elsif summit.first.shift == "設置電気"
          @result_summit_and_put_data = person_hash
        else
        end 
      end

      # 週間基準値
      if @result_summit.present?
        # 週毎の期間
        days = ["日", "月", "火", "水", "木", "金", "土"]
         if days[@start_date.wday] == "日" 
           week1 = (@start_date.since(1.days)) 
         elsif days[@start_date.wday] == "土" 
           week1 = (@start_date.ago(5.days))
         elsif days[@start_date.wday] == "金" 
           week1 = (@start_date.ago(4.days))
         elsif days[@start_date.wday] == "木" 
           week1 = (@start_date.ago(3.days)) 
         elsif days[@start_date.wday] == "水" 
           week1 = (@start_date.ago(2.days)) 
         elsif days[@start_date.wday] == "火" 
           week1 = (@start_date.ago(1.days)) 
         else 
          week1 = @start_date
         end
          @results_week1 = Result.where(user_id: @user.id).where(date: week1..(week1.since(6.days)))
          @results_week2 = Result.where(user_id: @user.id).where(date: (week1.since(7.days))..(week1.since(13.days)))
          @results_week3 = Result.where(user_id: @user.id).where(date: (week1.since(14.days))..(week1.since(20.days)))
          @results_week4 = Result.where(user_id: @user.id).where(date: (week1.since(21.days))..(week1.since(27.days)))
          @results_week5 = Result.where(user_id: @user.id).where(date: (week1.since(28.days))..(week1.since(34.days)))
      end
    end 

  end 

  # 獲得詳細 
  def person_data 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @user = User.find(params[:user_id])
    @year_parse = @month.in_time_zone.all_year
    @summits = Summit.where(user_id: @user.id).where(date: @month.beginning_of_month..@month.end_of_month)
    @month_group = Summit.where(user_id: @user.id).where(date: @year_parse)
    @metered_month_group = @month_group.where("contract_type LIKE ?", "%従量%").group("MONTH(date)").count
    @low_voltage_month_group = @month_group.where("contract_type LIKE ?", "%低圧電力%").group("MONTH(date)").count
    @metered_month_group_ave = @month_group.where("contract_type LIKE ?", "%従量%").group("MONTH(date)").average(:amount_use)
    @low_voltage_month_group_ave = @month_group.where("contract_type LIKE ?", "%低圧電力%").group("MONTH(date)").average(:amount_use)
  end 

  # 廃止案件一覧
  def repeal_data
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @year_parse = @month.in_time_zone.all_year
    @user = User.find(params[:user_id])
    @summits = Summit.includes(:summit_client).where(user_id: @user.id).where(summit_client: {cancel: @month.beginning_of_month..@month.end_of_month})
    @month_group = SummitClient.includes(:summit).where(summit: {user_id: @user.id}).where(cancel: @year_parse)
    @metered_month_group = @month_group.where("pay_menu LIKE ?", "%従量%").group("MONTH(cancel)").count
    @low_voltage_month_group = @month_group.where("pay_menu LIKE ?", "%低圧電力%").group("MONTH(cancel)").count

  end 

  # SWエラーデータ一覧
  def sw_error_data
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @user = User.find(params[:user_id])
    @summits = Summit.includes(:summit_client).where(user_id: @user.id).where(status: "SWエラー")

  end 

  # 支払遅延
  def error_history_data
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @year_parse = @month.in_time_zone.all_year
    @user = User.find(params[:user_id])
    @summits = SummitErrorHistory.includes(:user).where(user_id: @user.id).where(start_section: "*")

  end 

  # 対応履歴
  def customer_prop_data
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @year_parse = @month.in_time_zone.all_year
    @user = User.find(params[:user_id])
    @summits = SummitCustomerProp.includes(:user).where(user_id: @user.id).where(create_datetime: @month.beginning_of_month..@month.end_of_month).where(start_section: "*")

  end 

  # 明細
  def billing_data
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @year_parse = @month.year
    @billing_month = @month.strftime("%Y年%m月")
    @user = User.find(params[:user_id])
    @summits = SummitBillingAmount.includes(:user).where(user_id: @user.id).where(billing_date: @billing_month)


    @count_chart = [
      {
        name: "従量電灯", data: @counter_m = SummitBillingAmount.includes(:user).where(user_id: @user.id).where("contract_type LIKE ?", "%従量%").where("billing_date LIKE ?","%#{@year_parse}%").group(:billing_date).count
      },
      {
        name: "低圧電力", data: @counter_l = SummitBillingAmount.includes(:user).where(user_id: @user.id).where("contract_type LIKE ?", "%低圧%").where("billing_date LIKE ?","%#{@year_parse}%").group(:billing_date).count
      },
    ]

    @commission_chart = [
      {
        name: "合計", data: @commission_sum_m = SummitBillingAmount.includes(:user).where(user_id: @user.id).where("billing_date LIKE ?","%#{@year_parse}%").group(:billing_date).sum(:commission)
      },
      {
        name: "従量電灯", data: @commission_sum_l = SummitBillingAmount.includes(:user).where(user_id: @user.id).where("contract_type LIKE ?", "%従量%").where("billing_date LIKE ?","%#{@year_parse}%").group(:billing_date).sum(:commission)
      },
      {
        name: "低圧電力", data: SummitBillingAmount.includes(:user).where(user_id: @user.id).where("contract_type LIKE ?", "%低圧%").where("billing_date LIKE ?","%#{@year_parse}%").group(:billing_date).sum(:commission)
      },
    ]

    @commission_ave_chart = [
      {
        name: "従量電灯", data: @commission_m_ave = SummitBillingAmount.includes(:user).where(user_id: @user.id).where("contract_type LIKE ?", "%従量%").where("billing_date LIKE ?","%#{@year_parse}%").group(:billing_date).average(:commission)
      },
      {
        name: "低圧電力", data: @commission_l_ave = SummitBillingAmount.includes(:user).where(user_id: @user.id).where("contract_type LIKE ?", "%低圧%").where("billing_date LIKE ?","%#{@year_parse}%").group(:billing_date).average(:commission)
      },
    ]

    @total_use_ave_chart = [
      {
        name: "従量電灯", data: @total_use_m_ave = SummitBillingAmount.includes(:user).where(user_id: @user.id).where("contract_type LIKE ?", "%従量%").where("billing_date LIKE ?","%#{@year_parse}%").group(:billing_date).average(:total_use)
      },
      {
        name: "低圧電力", data: @total_use_l_ave = SummitBillingAmount.includes(:user).where(user_id: @user.id).where("contract_type LIKE ?", "%低圧%").where("billing_date LIKE ?","%#{@year_parse}%").group(:billing_date).average(:total_use)
      },
    ]
    

  end 

  # 売上予測
  def prediction_data
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @year_parse = @month.in_time_zone.all_year
    @prev_year = @month.prev_year.strftime("%Y年%m月")
    @user = User.find(params[:user_id])
    @billings = SummitBillingAmount.where(billing_date: @prev_year)
    @summits = Summit.includes(:summit_client).all
    @summits_user = @summits.where(user_id: @user.id)
    @summits_done = @summits_user.where(status: "SW完了")
    @summits_ng = @summits_user.where.not(status: "SW待ち").where.not(status: "処理待ち").where.not(status: "SW完了")
    


  end 

  def edit 
    @result_summit = ResultSummit.find(params[:id])
  end 
  
  def update 
    @result_summit_summit = ResultSummit.find(params[:id])
    @result_summit_summit.update(result_summit_params)
    redirect_to result_summit_path(@result_summit_summit.result.user_id)
  end

  def base_profit
    @month = params[:month] ? Date.parse(params[:month]) : Date.today
    @start_date = @month.beginning_of_month
    @end_date = @month.end_of_month
    @shifts = Shift.where(start_time: @start_date..@end_date)
    @results = Result.includes(:user).where(date: @start_date..@end_date)
    @results_summit = @results.where(shift: "電気")
    .or(
      @results.where(shift: "設置電気")
    )

    @user_ids = Summit.pluck(:user_id).uniq
    @chubu_ary = []
    @kansai_ary = []
    @kanto_ary = []
    @partner_ary = []
    @other_ary = []

    @user_ids.each do |user_id|
      user = User.find_by(id: user_id)
      person_hash = {}
      user_result = @results_summit.where(user_id: user.id)
      if user.position == "退職"
        person_hash["拠点"] = "退職"
      else
        if user.base_sub == "サミット"
          if user.base == "中部SS"
            person_hash["拠点"] = "中部SS"
          elsif user.base == "関西SS"
            person_hash["拠点"] = "関西SS"
          elsif user.base == "関東SS"
            person_hash["拠点"] = "関東SS"
          elsif user.base == "2次店"
            person_hash["拠点"] = "2次店"
          else  
            person_hash["拠点"] = "その他"
          end
        else
          person_hash["拠点"] = "その他"
        end 
      end

      person_hash["名前"] = user.name
      person_hash["役職"] = user.position_sub
      # 予定シフト
        user_shift = @shifts.where(user_id: user.id)
        person_hash["予定シフト"] = 
          user_shift.where(shift: "電気")
          .or(
            user_shift.where(shift: "設置電気")
          ).length
      # 消化シフト
        user_result = @results_summit.where(user_id: user.id)
        person_hash["消化シフト"] = user_result.length
        person_hash["帯同シフト"] = @results.where(user_id: user.id).where(shift: "帯同").length
      # 生産性
        user_summit_all = Summit.where(user_id: user.id)
        user_summit_sw_done = 
          user_summit_all.includes(:summit_client,:summit_price).where(status: "SW完了")
          .where(summit_client: {contract_start: ..Date.today.ago(30.days)}).where("contract_type LIKE ?","%従量%")
        # user_summit_all.includes(:summit_client,:summit_price)
        # .where(status: "SW完了")
        #   .where(summit_client: {contract_start: ..Date.today}).select('summits.*', 'count(summit_billing_amounts.id) AS billings')
        #   .left_joins(:summit_billing_amounts)
        #   .group('summits.id')
        #   .having('billings < 2').length
          # .sum(:last_billing).values.inject(:+)
        sw_done = user_summit_all.includes(:summit_client,:summit_price).where(status: "SW完了")
        .where(summit_client: {contract_start: ..Date.today.ago(30.days)})
        this_month_profit = sw_done.sum(:last_billing)
        price_ave = (this_month_profit / user_summit_all.where(status: "SW完了").where("contract_type LIKE ?","%従量%").length).round() rescue 0
          person_hash["当月売上"] = this_month_profit
          person_hash["単価"] = price_ave
        person_hash["切換完了済み"] = user_summit_sw_done.length
        # 明細の数が２個あるものとそうでないものと分ける
        
        user_summit = user_summit_all.where(date: @start_date..@end_date)
        metered_light = user_summit.where("contract_type LIKE ?","%従量%")
        person_hash["従量獲得"] = metered_light.length
        person_hash["従量獲得Ave"] = (person_hash["従量獲得"].to_f / person_hash["消化シフト"]).round(1) rescue 0
        person_hash["従量獲得終着見込"] = (person_hash["従量獲得Ave"] * person_hash["予定シフト"]).round() rescue 0
        person_hash["当月終着見込"] = person_hash["従量獲得終着見込"] * person_hash["単価"]
        person_hash["現状予想売上"] = person_hash["従量獲得"] * person_hash["単価"]

      # 基準値
        person_hash["訪問"] = (
          (
            user_result.sum(:first_visit) + 
            user_result.sum(:latter_visit)
          ) / person_hash["消化シフト"]
        ).round(1) rescue 0
        person_hash["対面"] = (
          (
            user_result.sum(:first_interview) + 
            user_result.sum(:latter_interview)
          ) / person_hash["消化シフト"]
        ).round(1) rescue 0
        person_hash["フル①"] = (
          (
            user_result.sum(:first_full_talk) + 
            user_result.sum(:latter_full_talk)
          ) / person_hash["消化シフト"]
        ).round(1) rescue 0
        person_hash["フル②"] = (
          (
            user_result.sum(:first_full_talk2) + 
            user_result.sum(:latter_full_talk2)
          ) / person_hash["消化シフト"]
        ).round(1) rescue 0
        person_hash["成約"] = (
          (
            user_result.sum(:first_get) + 
            user_result.sum(:latter_get)
          ) / person_hash["消化シフト"]
        ).round(1) rescue 0

      # ハッシュへデータを配列へ格納
      if person_hash["拠点"] == "その他"
        @other_ary << person_hash
      else
        if (user.base == "中部SS") && (user.position != "退職")
          @chubu_ary << person_hash
        elsif (user.base == "関西SS") && (user.position != "退職")
          @kansai_ary << person_hash
        elsif (user.base == "関東SS") && (user.position != "退職")
          @kanto_ary << person_hash
        elsif (user.base == "2次店") && (user.position != "退職")
          @partner_ary << person_hash
        elsif (user.position == "退職")
          @other_ary << person_hash
        end 
      end 
    end # /サミット終着がある人ごとに繰り返す

  end 



  private
  def result_summit_params
    params.require(:result_summit).permit(
      :result_id                          ,
      # 電力会社別基準値（訪問-成約）
      :power_company1_full_talk1          ,
      :power_company1_full_talk2          ,
      :power_company1_get                 ,
      :power_company2_full_talk1          ,
      :power_company2_full_talk2          ,
      :power_company2_get                 ,
      :power_company3_full_talk1          ,
      :power_company3_full_talk2          ,
      :power_company3_get                 ,
      :power_company4_full_talk1          ,
      :power_company4_full_talk2          ,
      :power_company4_get                 ,
      :power_company5_full_talk1          ,
      :power_company5_full_talk2          ,
      :power_company5_get                 ,
      :power_company6_full_talk1          ,
      :power_company6_full_talk2          ,
      :power_company6_get                 ,
      :power_company7_full_talk1          ,
      :power_company7_full_talk2          ,
      :power_company7_get                 ,
      :power_company8_full_talk1          ,
      :power_company8_full_talk2          ,
      :power_company8_get                 ,
      :power_company9_full_talk1          ,
      :power_company9_full_talk2          ,
      :power_company9_get                 ,
      # 業種別基準値（訪問-成約）
      :industry1_visit                    ,
      :industry1_get                      ,
      :industry2_visit                    ,
      :industry2_get                      ,
      :industry3_visit                    ,
      :industry3_get                      ,
      :industry4_visit                    ,
      :industry4_get                      ,
      :industry5_visit                    ,
      :industry5_get                      ,
      :industry6_visit                    ,
      :industry6_get                      ,
      :industry7_visit                    ,
      :industry7_get                      ,
      :industry8_visit                    ,
      :industry8_get                      ,
      :industry9_visit                    ,
      :industry9_get                      ,
      # 切り返し（フル①）
      :out_interview_01                   ,
      :out_full_talk_01                   ,
      :out_get_01                         ,
      :out_interview_02                   ,
      :out_full_talk_02                   ,
      :out_get_02                         ,
      :out_interview_03                   ,
      :out_full_talk_03                   ,
      :out_get_03                         ,
      :out_interview_04                   ,
      :out_full_talk_04                   ,
      :out_get_04                         ,
      :out_interview_05                   ,
      :out_full_talk_05                   ,
      :out_get_05                         ,
      :out_interview_06                   ,
      :out_full_talk_06                   ,
      :out_get_06                         ,
      :out_interview_07                   ,
      :out_full_talk_07                   ,
      :out_get_07                         ,
      :out_interview_08                   ,
      :out_full_talk_08                   ,
      :out_get_08                         ,
      :out_interview_09                   ,
      :out_full_talk_09                   ,
      :out_get_09                         ,
      :out_interview_10                   ,
      :out_full_talk_10                   ,
      :out_get_10                         ,
      # 切り返し（フル②）
      :out2_interview_01                  ,
      :out2_full_talk_01                  ,
      :out2_get_01                        ,
      :out2_interview_02                  ,
      :out2_full_talk_02                  ,
      :out2_get_02                        ,
      :out2_interview_03                  ,
      :out2_full_talk_03                  ,
      :out2_get_03                        ,
      :out2_interview_04                  ,
      :out2_full_talk_04                  ,
      :out2_get_04                        ,
      :out2_interview_05                  ,
      :out2_full_talk_05                  ,
      :out2_get_05                        ,
      :out2_interview_06                  ,
      :out2_full_talk_06                  ,
      :out2_get_06                        ,
      :out2_interview_07                  ,
      :out2_full_talk_07                  ,
      :out2_get_07                        ,
      :out2_interview_08                  ,
      :out2_full_talk_08                  ,
      :out2_get_08                        ,
      :out2_interview_09                  ,
      :out2_full_talk_09                  ,
      :out2_get_09                        ,
      :out2_interview_10                  ,
      :out2_full_talk_10                  ,
      :out2_get_10                        ,
      :out2_interview_11                  ,
      :out2_full_talk_11                  ,
      :out2_get_11                        ,
      :out2_interview_12                  ,
      :out2_full_talk_12                  ,
      :out2_get_12                        ,
      :out2_interview_13                  ,
      :out2_full_talk_13                  ,
      :out2_get_13                        ,
      :out2_interview_14                  ,
      :out2_full_talk_14                  ,
      :out2_get_14                        ,
      :out2_interview_15                  ,
      :out2_full_talk_15                  
    )
  end 
end
