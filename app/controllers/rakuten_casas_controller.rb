class RakutenCasasController < ApplicationController

  def index 
    @q = RakutenCasa.includes(:store_prop).ransack(params[:q])
    @rakuten_casas = 
      if params[:q].nil?
        RakutenCasa.none 
      else  
        @q.result(distinct: true)
      end
  end 

  def new 
    @rakuten_casa = RakutenCasa.new 
    @store_prop = StoreProp.find(params[:store_prop_id])
  end 
  
  def create 
    @rakuten_casa = RakutenCasa.new(rakuten_casa_params)
    @store_prop = StoreProp.find(params[:store_prop_id])
    if @rakuten_casa.save 
      redirect_to rakuten_casas_path 
    else  
      render :new 
    end
  end 

  def import 
    if params[:file].present?
      if RakutenCasa.csv_check(params[:file]).present?
        redirect_to rakuten_casas_path , alert: "エラーが発生したため中断しました#{RakutenCasa.csv_check(params[:file])}"
      else
        message = RakutenCasa.import(params[:file]) 
        redirect_to rakuten_casas_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to rakuten_casas_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def show 
    @rakuten_casa = RakutenCasa.find(params[:id])
  end

  def edit 
    @rakuten_casa = RakutenCasa.find(params[:id])
  end 
  
  def update 
    @rakuten_casa = RakutenCasa.find(params[:id])
    @rakuten_casa.update(rakuten_casa_params)
    redirect_to rakuten_casa_path(params[:id])
  end 
  
  private 
  def rakuten_casa_params 
    params.require(:rakuten_casa).permit(
      # 新規 17
      :client                  ,
      :user_id                 ,                
      :store_prop_id           ,          
      :date                    ,         
      :status                  ,       
      :status_update           ,       
      :net_confirm_method      ,       
      :net_name                ,      
      :hikari_collabo          ,       
      :net_plan                ,       
      :customer_num            ,
      :net_address             ,       
      :net_contracter          ,       
      :net_contracter_kana     ,       
      :net_phone_number        ,
      :remarks                 ,
      :share                   ,
      # 自社不備 4 
      :deficiency              ,
      :status_deficiency       ,
      :deficiency_solution     ,
      :deficiency_remarks      ,
      # 回線不備 7
      :deficiency_net          ,
      :status_deficiency_net   ,
      :deficiency_share_net    ,
      :deficiency_last_shared_net,
      :deficiency_result_net   ,
      :deficiency_remarks_net  ,
      :deficiency_solution_net ,
      # 反社不備 7
      :deficiency_anti          ,
      :status_deficiency_anti   ,
      :deficiency_share_anti    ,
      :deficiency_last_shared_anti,
      :deficiency_result_anti   ,
      :deficiency_remarks_anti  ,
      :deficiency_solution_anti ,
      # 端末情報 5
      :order                    ,
      :arrival                 ,
      :femto_id                ,
      :inspection              ,
      :done_oss                , # 第一成果地点
      # 設置 6
      :put_plan                ,
      :put                     ,
      :putter_id               ,
      :radio_waves             ,
      :google_form_share       ,
      :status_put              ,
      # 図書 7
      :share_book              ,
      :status_book             ,
      :deficiency_book         ,
      :deficiency_remarks_book ,
      :deficiency_result_book  ,
      :deficiency_solution_book,
      :done_book               , #第二成果地点 
      # 未完図書 4
      :share_undone_book       ,
      :status_undone_book      ,
      :deficiency_solution_undone_book,
      :done_undone_book        , #第二成果地点
      # システム調整 9
      :radio_waves_undone      ,
      :put_adjustment          ,
      :adjustmenter_id         ,
      :share_adjustment        ,
      :deficiency_adjustment   ,
      :deficiency_solution_adjustment,
      :google_form_share_adjustment,
      :adjustment_status       ,
      :done_adjustment         ,#第三成果地点
      # 申込書 4
      :share_app               ,
      :app_create              ,
      :status_app              ,
      :done_app                ,
      # 覚書 6
      :share_memo              ,
      :memo_create             ,
      :status_memo             ,
      :done_memo               ,
      :letter_pack_num1        ,
      :letter_pack_num2        ,
      # 入金、売上 6
      :payment                 ,
      :payment_put             ,
      :profit_new              ,
      :profit_put              , 
      :valuation_new           , 
      :valuation_put           ,      
      )
    end 
    
    
  end
  