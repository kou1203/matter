class StorePropsController < ApplicationController
  before_action :authenticate_user!
  before_action :back_retirement, only: [:index]
  def index 
    @q = StoreProp.ransack(params[:q])
    @store_props = 
      if params[:q].nil?
        StoreProp.none 
      else
        @q.result(distinct: true)
      end
  end 

  def new 
    @store_prop = StoreProp.new
  end 

  def create 
    @store_prop = StoreProp.new(store_prop_params)
    if @store_prop.save
      redirect_to store_prop_path(@store_prop.id)
    else 
      render :new
    end

  end 

  def edit 
    @store_prop = StoreProp.find(params[:id])
  end 
  
  def update 
    @store_prop = StoreProp.find(params[:id])
    @store_prop.update(store_prop_params)
    redirect_to store_prop_path(@store_prop.id)
  end 

  def import 
    if params[:file].present?
      if StoreProp.csv_check(params[:file]).present?
        redirect_to store_props_path , alert: "エラーが発生したため中断しました#{StoreProp.csv_check(params[:file])}"
      else
        message = StoreProp.import(params[:file]) 
        redirect_to store_props_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to store_props_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def show 
    @store_prop = StoreProp.find(params[:id])
    @dmer = @store_prop.dmer
    @aupay = @store_prop.aupay
    @paypay = @store_prop.paypay
    @praness = @store_prop.praness
    @rakuten_casa = @store_prop.rakuten_casa
    @st_insurance = @store_prop.st_insurance
    @rakuten_pay = @store_prop.rakuten_pay
    @summit_customer_prop = @store_prop.summit_customer_prop
    if @summit_customer_prop.nil?
      @summits = 0
    else  
      @summits = @summit_customer_prop.summits
    end

    @panda = @store_prop.pandas 
  end

  private 

  def back_retirement
    redirect_to error_pages_path if current_user.position == "退職"
  end

  def store_prop_params
    params.require(:store_prop).permit(
      :race,
      :name,
      :corporate_name,
      :corporate_address,
      :corporate_num,
      :industry,
      :gender_main, 
      :person_main_name, 
      :person_main_kana,
      :person_main_class,
      :person_main_birthday, 
      :gender_sub, 
      :person_sub_name, 
      :person_sub_kana, 
      :person_sub_class, 
      :person_sub_birthday, 
      :phone_number_1,
      :phone_number_2, 
      :mail_1,
      :mail_2,
      :prefecture, 
      :city, 
      :municipalities,
      :address, 
      :building_name, 
      :suitable_time, 
      :holiday,
      :head_store, 
      :description,
      )
    end 
  end
  