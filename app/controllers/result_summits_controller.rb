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
    @results = Result.includes(:result_summit).where(user_id: @user.id).where(date: @start_date..@end_date)
    @result_summit = @results.where(shift: "サミット")
    @result_ojt = @results.where(shift: "帯同")
    @result_office_work = @results.where(shift: "内勤")
    @shifts = Shift.where(user_id: @user.id).where(start_time: @start_date..@end_date)
    @shift_summit = @shifts.where(shift: "サミット")
    @shift_ojt = @shifts.where(shift: "帯同")
    @shift_office_work = @shifts.where(shift: "内勤")

      #  合計変数 
      @sum_visit = @results.where(shift: "サミット").sum("first_visit + latter_visit") 
      @sum_interview = @results.where(shift: "サミット").sum("first_interview + latter_interview") 
      @sum_full_talk = @results.where(shift: "サミット").sum("first_full_talk + latter_full_talk") 
      @sum_full_talk2 = @results.where(shift: "サミット").sum("first_full_talk2 + latter_full_talk2") 
      @sum_get = @results.where(shift: "サミット").sum("first_get + latter_get") 
      @revisit_full_talk = @results.where(shift: "サミット").sum(:revisit_full_talk) 
      @revisit_get = @results.where(shift: "サミット").sum(:revisit_get) 
      @standard_label_ary = ["訪問","対面","フル①","フル②","成約"]
      @standard_val_ary = [@sum_visit,@sum_interview,@sum_full_talk,@sum_full_talk2,@sum_get]
     #  前半変数  
      @sum_visit_f = @results.where(shift: "サミット").sum(:first_visit) 
      @sum_interview_f = @results.where(shift: "サミット").sum(:first_interview) 
      @sum_full_talk_f = @results.where(shift: "サミット").sum(:first_full_talk) 
      @sum_full_talk2_f = @results.where(shift: "サミット").sum(:first_full_talk2) 
      @sum_get_f = @results.where(shift: "サミット").sum(:first_get) 
      @standard_val_ary_f = [@sum_visit_f,@sum_interview_f,@sum_full_talk_f,@sum_full_talk2_f,@sum_get_f]
      # 後半変数 
      @sum_visit_l = @results.where(shift: "サミット").sum(:latter_visit) 
      @sum_interview_l = @results.where(shift: "サミット").sum(:latter_interview) 
      @sum_full_talk_l = @results.where(shift: "サミット").sum(:latter_full_talk) 
      @sum_full_talk2_l = @results.where(shift: "サミット").sum(:latter_full_talk2) 
      @sum_get_l = @results.where(shift: "サミット").sum(:latter_get) 
      @standard_val_ary_l = [@sum_visit_l,@sum_interview_l,@sum_full_talk_l,@sum_full_talk2_l,@sum_get_l]
      @sum_revisit_full_talk = @results.where(shift: "サミット").sum(:revisit_full_talk) 
      @sum_revisit_get = @results.where(shift: "サミット").sum(:revisit_get) 
      @revisit_label_ary = ["フル②", "成約"]
      @revisit_val_ary = [@sum_revisit_full_talk, @sum_revisit_get]
      # 電力会社
      @sum_power_company1_full_talk = @results.where(shift: "サミット").sum(:power_company1_full_talk1) 
      @sum_power_company1_full_talk2 = @results.where(shift: "サミット").sum(:power_company1_full_talk2) 
      @sum_power_company1_get = @results.where(shift: "サミット").sum(:power_company1_get) 
      @sum_power_company2_full_talk = @results.where(shift: "サミット").sum(:power_company2_full_talk1) 
      @sum_power_company2_full_talk2 = @results.where(shift: "サミット").sum(:power_company2_full_talk2) 
      @sum_power_company2_get = @results.where(shift: "サミット").sum(:power_company2_get) 
      @sum_power_company3_full_talk = @results.where(shift: "サミット").sum(:power_company3_full_talk1) 
      @sum_power_company3_full_talk2 = @results.where(shift: "サミット").sum(:power_company3_full_talk2) 
      @sum_power_company3_get = @results.where(shift: "サミット").sum(:power_company3_get) 
      @sum_power_company4_full_talk = @results.where(shift: "サミット").sum(:power_company4_full_talk1) 
      @sum_power_company4_full_talk2 = @results.where(shift: "サミット").sum(:power_company4_full_talk2) 
      @sum_power_company4_get = @results.where(shift: "サミット").sum(:power_company4_get) 
      @power_company_label_ary = ["地域電力", "地域ガス", "ハルエネ", "その他"]
      @power_company_label_ary2 = ["フル①", "フル②", "成約"]
  end 

  def edit 
    @result_summit = ResultSummit.find(params[:id])
  end 
  
  def update 
    @result_summit_summit = ResultSummit.find(params[:id])
    @result_summit_summit.update(result_summit_params)
    redirect_to result_summit_path(@result_summit_summit.result.user_id)
  end



  private
  def result_summit_params
    params.require(:result_summit).permit(
      :result_id                          ,
      # 電力会社別基準値（訪問-獲得）
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
      # 業種別基準値（訪問-獲得）
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
