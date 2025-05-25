class ResultTypesController < ApplicationController
  def new
    @result = Result.find(params[:result_id])
    @visit_types = ["QRのみ", "未導入", "マルチ決済"]
    # 親レコードを3つ作成
    @result_types = Array.new(3) do
      result_type = ResultType.new
      6.times { result_type.deal_attributes.build } # 各親に子6件
      result_type
    end
  end

  def create
    @result = Result.find(params[:result_id])
    permitted_params = params.permit(result_types: [
      :result_id ,:visit_type, 
      deal_attributes_attributes: [:key, :val]
    ])
    @result_types = permitted_params[:result_types].map do |p_param|
      ResultType.new(p_param)
    end
    success = true
    ActiveRecord::Base.transaction do
      @result_types.each_with_index do |parent, index|
        unless parent.save
          success = false
          logger.debug "❌ Parent #{index} failed to save: #{parent.errors.full_messages}"
          parent.deal_attributes.each_with_index do |child, c_index|
            logger.debug "  └─ Child #{c_index} errors: #{child.errors.full_messages}" unless child.valid?
          end
        end
      end
  
      raise ActiveRecord::Rollback unless success
    end
  
    redirect_to  result_result_cashes_new_path(@result.id)
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "保存に失敗しました: #{e.message}"
    render :new
  end
end