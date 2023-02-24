class ProductCheckersController < ApplicationController
  def index 
    @q = ProductChecker.ransack(params[:q])
    @products = 
      if params[:q].nil?
        ProductChecker.none 
      else
        @q.result(distinct: false)
      end
      @products_data = @products.page(params[:page]).per(100)
      @products = ProductChecker.all
  end
end

private

