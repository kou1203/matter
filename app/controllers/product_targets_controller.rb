class ProductTargetsController < ApplicationController

  def new
    @form = Form::ProductTargetCollection.new
  end 

  def create 
    @form = Form::ProductTargetCollection.new(product_target_params)
    if @form.save
      redirect_to results_path, notice: "登録しました"
    else
      flash.now[:alert] = "登録に失敗しました"
      render :new
    end
  end

  def edit 
    @product_target = ProductTarget.find(params[:id])
  end 

  def update 
    @product_target = ProductTarget.find(params[:id])
    @product_target.update(target_update)
    redirect_to results_path, notice: "目標獲得数を修正しました"
  end 

  private 
  def product_target_params 
    params.require(:form_product_target_collection).permit(product_targets_attributes:[:date,:base,:product,:product_len,:product_valuations])
  end
  def target_update 
    params.require(:product_target).permit(
      :date,
      :base,
      :product,
      :product_len,
      :product_valuations
    )
  end 
end
