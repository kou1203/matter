class CreateNResults < ActiveRecord::Migration[6.0]
  def change
    create_table :n_results do |t|
      t.references :user                , foreign_key: true 
      t.date :date                      , null: false
      t.string :base                    , null:false 
      t.string :area                    , null:false 
      t.string :ojt    
      t.integer :profit                 , null:false 
      # 基準値
      # 前半
      t.integer :first_visit             
      t.integer :first_reply             
      t.integer :first_interview             
      t.integer :first_full_talk             
      t.integer :first_write             
      t.integer :first_get                     
      # 後半
      t.integer :latter_visit             
      t.integer :latter_reply             
      t.integer :latter_interview             
      t.integer :latter_full_talk             
      t.integer :latter_write             
      t.integer :latter_get         
      # 夜間
      t.integer :night_visit             
      t.integer :night_reply             
      t.integer :night_interview             
      t.integer :night_full_talk             
      t.integer :night_write             
      t.integer :night_get                    
      # 訪問内訳
      t.integer :detached_a                          
      t.integer :detached_get                          
      t.integer :apartment_a                          
      t.integer :apartment_get                          
      t.integer :family_apartment_a                          
      t.integer :family_apartment_get                          
      t.integer :auto_single_a                          
      t.integer :auto_single_get       
      t.integer :auto_family_a                          
      t.integer :auto_family_get       
      
      t.integer :door_take                          
      t.integer :easy   
      t.integer :auto_through_a                       
      t.integer :auto_through_b                       
      t.integer :close_soon         
      
      # 既存基準値
      t.integer :existing_visit             
      t.integer :existing_interview             
      t.integer :existing_full_talk             
      t.integer :existing_get                       
      # 契約変更・再開（既存内訳）
      t.integer :contract_change_interview
      t.integer :contract_change_full_talk
      t.integer :contract_change_get
      t.integer :resum_payment_interview                   
      t.integer :resum_payment_full_talk                   
      t.integer :resum_payment_get 
      t.integer :transfer_get
      # キャッチ                  
      t.integer :catch_call                  
      t.integer :catch_interview                  
      t.integer :catch_full_talk                  
      t.integer :catch_get                  
      # 事業所
      t.integer :office_visit                  
      t.integer :office_interview                  
      t.integer :office_full_talk                  
      t.integer :office_get                  
      # 商材
      t.integer :terrestrial_new                     
      t.integer :satellite_new                     
      t.integer :account_new                     
      t.integer :credit_new                     
      t.integer :terrestrial_transfer                     
      t.integer :satellite_transfer                     
      t.integer :free_transfer                     
      t.integer :contract_change                   
      t.integer :resum_payment                   
      t.integer :resum_payment_account                   
      t.integer :resum_payment_credit                   
      t.integer :resum_payment_num                   
      t.integer :payment_change                  
      t.integer :receipt_num             
      t.integer :receipt_account             
      t.integer :office       
      # 切り返し      
      # 基本切り返し
      t.integer :no_watch_a       
      t.integer :no_watch_b       
      t.integer :no_watch_c       
      t.integer :no_watch_get       
      t.integer :not_everyone_a       
      t.integer :not_everyone_b       
      t.integer :not_everyone_c       
      t.integer :not_everyone_get       
      t.integer :throw_away_a       
      t.integer :throw_away_b       
      t.integer :throw_away_c       
      t.integer :throw_away_get       
      t.integer :suddenly_a       
      t.integer :suddenly_b       
      t.integer :suddenly_c       
      t.integer :suddenly_get       
      t.integer :another_contract_a       
      t.integer :another_contract_b       
      t.integer :another_contract_c       
      t.integer :another_contract_get       
      t.integer :no_thank_you_a       
      t.integer :no_thank_you_b       
      t.integer :no_thank_you_c       
      t.integer :no_thank_you_get       
      t.integer :late_night_a       
      t.integer :late_night_b       
      t.integer :late_night_c       
      t.integer :late_night_get       
      # 先延ばし
      t.integer :busy_a       
      t.integer :busy_b       
      t.integer :busy_c       
      t.integer :busy_get       
      t.integer :do_it_a       
      t.integer :do_it_b       
      t.integer :do_it_c       
      t.integer :do_it_get       
      t.integer :think_a       
      t.integer :think_b       
      t.integer :think_c       
      t.integer :think_get       
      # 第三者
      t.integer :partner_a       
      t.integer :partner_b       
      t.integer :partner_c       
      t.integer :partner_get       
      t.integer :company_a       
      t.integer :company_b       
      t.integer :company_c       
      t.integer :company_get       
      t.integer :student_a       
      t.integer :student_b       
      t.integer :student_c       
      t.integer :student_get       
      # スキル
      t.integer :no_money_a       
      t.integer :no_money_b       
      t.integer :no_money_c       
      t.integer :no_money_get       
      t.integer :not_here_a       
      t.integer :not_here_b       
      t.integer :not_here_c       
      t.integer :not_here_get       
      t.integer :no_payment_a       
      t.integer :no_payment_b       
      t.integer :no_payment_c       
      t.integer :no_payment_get       
      t.integer :foreign_a       
      t.integer :foreign_b       
      t.integer :foreign_c       
      t.integer :foreign_get       
      # その他
      t.integer :difficult_deal_a       
      t.integer :difficult_deal_b       
      t.integer :difficult_deal_c       
      t.integer :difficult_deal_get       
      t.integer :past_trouble_a       
      t.integer :past_trouble_b       
      t.integer :past_trouble_c       
      t.integer :past_trouble_get       
      t.integer :trial_hope_a       
      t.integer :trial_hope_b       
      t.integer :trial_hope_c       
      t.integer :trial_hope_get       
      t.integer :other_a       
      t.integer :other_b       
      t.integer :other_c       
      t.integer :other_get       
      # 機器なし
      t.integer :no_tv_a       
      t.integer :no_tv_b       
      t.integer :no_tv_c       
      t.integer :no_tv_get       
      t.integer :no_tv_excavation       
      t.integer :no_tv_excavation_ng       
      t.integer :breaking_tv_a       
      t.integer :breaking_tv_b       
      t.integer :breaking_tv_c       
      t.integer :breaking_tv_get       
      t.integer :breaking_tv_excavation       
      t.integer :breaking_tv_excavation_ng       
    end
  end
end
