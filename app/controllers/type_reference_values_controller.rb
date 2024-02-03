class TypeReferenceValuesController < ApplicationController

  def new 
    @type_reference_value = TypeReferenceValue.new
    @result = Result.find(params[:result_id])
  end 
  
  def create 
    @result = Result.find(params[:result_id])
    @type_reference_value = TypeReferenceValue.new(type_reference_value_params)
    if @type_reference_value.save 
      redirect_to  result_result_cashes_new_path(@result.id)
    else  
      render :new
    end
  end

  def edit 
    @type_reference_value = TypeReferenceValue.find(params[:id])
    session[:previous_url] = request.referer
  end 

  def update 
    @type_reference_value = TypeReferenceValue.find(params[:id])
    @type_reference_value.update(type_reference_value_params)
    redirect_to session[:previous_url] , alert: "訪問種別基準値の内容を更新しました。"
  end 

  private 
  def type_reference_value_params
    params.require(:type_reference_value).permit(
      :result_id       ,
      :type1           ,
      :type2           ,
      :type1_a         ,
      :type1_b         ,
      :type1_c         ,
      :type1_d         ,
      :type1_e         ,
      :type2_a         ,
      :type2_b         ,
      :type2_c         ,
      :type2_d         ,
      :type2_e         
     
    )
  end 

end
