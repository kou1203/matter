class OtherProductsController < ApplicationController

  def new
    @other_product = OtherProduct.new

  end

  def create 
    @other_product = OtherProduct.new(other_product_params)
    if @other_product.product_name = "auPay写真"
      @other_product[:valuation] = @other_product.product_len * 1500
      @other_product[:profit] = @other_product.product_len * 2500
    end
    if @other_product.save 
      redirect_to root_path, alert: "入力された獲得情報が保存されました。"
    else  
      render :new 
    end
  end

  def edit 
  end 

  def update 
  end 

  private
  def other_product_params
    params.require(:other_product).permit(
      :user_id,
      :date,
      :product_name,
      :product_len,
      :profit,
      :valuation,
    )
  end
end
