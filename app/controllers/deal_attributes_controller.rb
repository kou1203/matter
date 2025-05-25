class DealAttributesController < ApplicationController
  before_action :set_result_type

  def edit_all
    @deal_attributes = @result_type.deal_attributes
    @result = Result.find(@result_type.result_id)
    session[:previous_url] = request.referer
  end

  def update_all
    @result_type.deal_attributes.each do |deal_attribute|
      raw = params[:deal_attributes][deal_attribute.id.to_s]
      next unless raw

      permitted = raw.is_a?(ActionController::Parameters) ? raw.permit(:key, :val) : ActionController::Parameters.new(raw).permit(:key, :val)
      deal_attribute.update(permitted)
    end
    redirect_to session[:previous_url]
  end

  private

  def set_result_type
    @result_type = ResultType.find(params[:result_type_id])
  end
end
