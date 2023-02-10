class OtherProductsController < ApplicationController

  def index 
    @q = OtherProduct.ransack(params[:q])
    @other_products = 
      if params[:q].nil?
        OtherProduct.none 
      else
        @q.result(distinct: false)
      end
      @other_products_data = @other_products.page(params[:page]).per(100)
  end 

  def new
    @other_product = OtherProduct.new

  end

  def create 
    @other_product = OtherProduct.new(other_product_new_params)
    if @other_product.product_name == "auPay写真"
      @other_product[:valuation] = @other_product.product_len * 1500
      @other_product[:profit] = @other_product.product_len * 2500
    elsif @other_product.product_name == "dメルステッカー"
      @other_product[:valuation] = @other_product.product_len * 1500
      @other_product[:profit] = @other_product.product_len * 3000
    elsif @other_product.product_name == "AirPayステッカー（自社）"
      @other_product[:valuation] = @other_product.product_len * 3000
      @other_product[:profit] = @other_product.product_len * 10000
    elsif @other_product.product_name == "AirPayステッカー（他社）"
      @other_product[:valuation] = @other_product.product_len * 4000
      @other_product[:profit] = @other_product.product_len * 10000
    end
    if @other_product.save 
      redirect_to results_path, alert: "入力された獲得情報が保存されました。"
    else  
      render :new 
    end
  end

  def edit 
    @other_product = OtherProduct.find(params[:id])
    session[:previous_url] = request.referer
  end 
  
  def update 
    @other_product = OtherProduct.find(params[:id])
    if @other_product.product_name == "auPay写真"
      @other_product.update(other_product_params)
      @other_product.update(set_other_product_params)
      redirect_to session[:previous_url], alert: "入力された獲得情報が編集されました。"
    elsif @other_product.product_name == "dメルステッカー"
      @other_product.update(other_product_params)
      @other_product.update(set_dmersticker_product_params)
      redirect_to session[:previous_url], alert: "入力された獲得情報が編集されました。"
    elsif @other_product.product_name == "AirPayステッカー（自社）"
      @other_product.update(other_product_params)
      @other_product.update(set_airpaysticker_mine_product_params)
      redirect_to session[:previous_url], alert: "入力された獲得情報が編集されました。"
    elsif @other_product.product_name == "AirPayステッカー（他社）"
      @other_product.update(other_product_params)
      @other_product.update(set_airpaysticker_other_product_params)
      redirect_to session[:previous_url], alert: "入力された獲得情報が編集されました。"
    else  
      render :edit
    end
    
    
    
  end 

  private
  def other_product_new_params
    params.require(:other_product).permit(
      :user_id,
      :date,
      :product_name,
      :product_len,
      :profit,
      :valuation,
    )
  end
  def other_product_params
    params.require(:other_product).permit(
      :user_id,
      :date,
      :product_name,
      :product_len,
    )
  end

  def set_other_product_params
    other_product_params.merge(@other_product.set_aupay_pic_params)
  end 

  def set_dmersticker_product_params
    other_product_params.merge(@other_product.set_dmer_pic_params)
  end 

  def set_airpaysticker_mine_product_params
    other_product_params.merge(@other_product.set_airpay_pic_mine_params)
  end 
  def set_airpaysticker_other_product_params
    other_product_params.merge(@other_product.set_airpay_pic_other_params)
  end 
  
end
