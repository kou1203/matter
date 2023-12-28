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
    @select_columns = SelectColumn.where(category: "その他商材名")
    if params[:user_id].present?
      @user = User.find(params[:user_id])
    else  
      @user = current_user
    end
    @other_product = OtherProduct.new

  end

  def create 
    @other_product = OtherProduct.new(other_product_params)
    if @other_product.save 
      redirect_to valuation_list_results_path(u_id: @other_product.user_id), alert: "#{@other_product.user.name}の#{@other_product.product_name}を獲得した情報を保存しました。"
    else  
      render :new 
    end
  end

  def edit 
    @select_columns = SelectColumn.where(category: "その他商材名")
    @other_product = OtherProduct.find(params[:id])
    session[:previous_url] = request.referer
  end 
  
  def update 
    @other_product = OtherProduct.find(params[:id])
    @other_product.update(other_product_params)
    @other_product.update(other_product_params)
    redirect_to session[:previous_url], alert: "#{@other_product.user.name}の#{@other_product.product_name}を獲得した情報を更新しました。"
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
