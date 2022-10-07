class ResultSummitsController < ApplicationController


  def new 
    @result = Result.find(params[:result_id])
    @result_summit = ResultSummit.new 
  end 
  
  def create 
    @result = Result.find(params[:result_id])
    @result_summit = ResultSummit.new(result_summit_params)
    if @result_summit.save 
      # if @result_summit.shift == "サミット"
      #   redirect_to  result_result_summits_new_path(@result_summit.id)
      # else  
      #   redirect_to results_path
      # end  
      redirect_to results_path
    else  
      render :new 
    end
  end

  def show 
    @result_summit_summit = ResultSummit.find(params[:id])
    @q = Result.ransack(params[:q])
    @result_summits = 
    if params[:q].nil? 
      Result.none 
    else    
      @q.result(distinct: false)
    end

  end 

  def edit 
    @result_summit = ResultSummit.find(params[:id])
  end 
  
  def update 
    @result_summit_summit = ResultSummit.find(params[:id])
    @result_summit_summit.update(result_summit_params)
    redirect_to results_path
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
