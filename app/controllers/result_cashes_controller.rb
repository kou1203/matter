class ResultCashesController < ApplicationController

  def new 
    @form = Form::ResultCashCollection.new()
    @result = Result.find(params[:result_id])
    @out_products = {"QRのみ": 0, "未導入": 1, "マルチ決済": 2}
  end 
  
  def create 
    @form = Form::ResultCashCollection.new(result_cash_collection_params)
    # @result = Result.find(params[:result_id])
    # @result_cash = ResultCash.new(result_cash_params)
    if @form.save
      redirect_to results_path
    else  
      render :new 
    end
  end

  def show 
    @result_cash = ResultCash.find(params[:id])
  end 

  def edit 
    @result_cash = ResultCash.find(params[:id])
    session[:previous_url] = request.referer
  end 
  
  def update 
    @result_cash = ResultCash.find(params[:id])
    @result_cash.update(result_cash_params)
    redirect_to session[:previous_url]
    # user_path(@result_cash.result.user_id)
  end


  def import 
    if params[:file].present?
      if ResultCash.csv_check(params[:file]).present?
        redirect_to results_path , alert: "エラーが発生したため中断しました#{ResultCash.csv_check(params[:file])}"
      else
        message = ResultCash.import(params[:file]) 
        redirect_to results_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to results_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 


  private
  def result_cash_collection_params
    params.require(:form_result_cash_collection).permit(result_cashes_attributes: [
      :result_id,
      # 対象外・NG
      :ng_01,
      :ng_02,
      :ng_03,
      # 切り返し    
      :out_interview_01,
      :out_full_talk_01,
      :out_get_01,
      :out_interview_02,
      :out_full_talk_02,
      :out_get_02,
      :out_interview_03,
      :out_full_talk_03,
      :out_get_03,
      :out_interview_04,
      :out_full_talk_04,
      :out_get_04,
      :out_interview_05,
      :out_full_talk_05,
      :out_get_05,
      :out_interview_06,
      :out_full_talk_06,
      :out_get_06,
      :out_interview_07,
      :out_full_talk_07,
      :out_get_07,
      :out_interview_08,
      :out_full_talk_08,
      :out_get_08,
      :out_interview_09,
      :out_full_talk_09,
      :out_get_09,
      :out_interview_10,
      :out_full_talk_10,
      :out_get_10,
      :out_interview_11,
      :out_full_talk_11,
      :out_get_11,
      :out_interview_12,
      :out_full_talk_12,
      :out_get_12,
      :out_interview_13,
      :out_full_talk_13,
      :out_get_13,
      :out_interview_14,
      :out_full_talk_14,
      :out_get_14,
      :out_interview_15,
      :out_full_talk_15,
      :out_get_15,
      :out_interview_16,
      :out_full_talk_16,
      :out_get_16,
      :out_interview_17,
      :out_full_talk_17,
      :out_get_17,
      :out_interview_18,
      :out_full_talk_18,
      :out_get_18,
      :out_interview_19,
      :out_full_talk_19,
      :out_get_19,
      :out_interview_20,
      :out_full_talk_20,
      :out_get_20,
      :dmer,
      :aupay,
      :paypay,
      :rakuten_pay,
      :airpay,
      :other_product1,
      :other_product10,
  ])
  end
  def result_cash_params
    params.require(:result_cash).permit(
      :result_id,
      # 対象外・NG
      :ng_01,
      :ng_02,
      :ng_03,
      # 切り返し    
      :out_interview_01,
      :out_full_talk_01,
      :out_get_01,
      :out_interview_02,
      :out_full_talk_02,
      :out_get_02,
      :out_interview_03,
      :out_full_talk_03,
      :out_get_03,
      :out_interview_04,
      :out_full_talk_04,
      :out_get_04,
      :out_interview_05,
      :out_full_talk_05,
      :out_get_05,
      :out_interview_06,
      :out_full_talk_06,
      :out_get_06,
      :out_interview_07,
      :out_full_talk_07,
      :out_get_07,
      :out_interview_08,
      :out_full_talk_08,
      :out_get_08,
      :out_interview_09,
      :out_full_talk_09,
      :out_get_09,
      :out_interview_10,
      :out_full_talk_10,
      :out_get_10,
      :out_interview_11,
      :out_full_talk_11,
      :out_get_11,
      :out_interview_12,
      :out_full_talk_12,
      :out_get_12,
      :out_interview_13,
      :out_full_talk_13,
      :out_get_13,
      :out_interview_14,
      :out_full_talk_14,
      :out_get_14,
      :out_interview_15,
      :out_full_talk_15,
      :out_get_15,
      :out_interview_16,
      :out_full_talk_16,
      :out_get_16,
      :out_interview_17,
      :out_full_talk_17,
      :out_get_17,
      :out_interview_18,
      :out_full_talk_18,
      :out_get_18,
      :out_interview_19,
      :out_full_talk_19,
      :out_get_19,
      :out_interview_20,
      :out_full_talk_20,
      :out_get_20,
      :dmer,
      :aupay,
      :paypay,
      :rakuten_pay,
      :airpay,
      :other_product1,
      :other_product10,
    )
  end 
end
