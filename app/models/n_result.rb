class NResult < ApplicationRecord
  belongs_to :user
  with_options presence: true do 
    validates :user_id 
    validates :date
    validates :base 
    validates :area
    validates :profit
  end 

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      store = find_by(id: row["id"]) || new 
      store.attributes = row.to_hash.slice(*updatable_attributes)
      store.save
    end
  end

  def self.updatable_attributes
    [
     "user_id",
     "date",
      "base",
      "area"         ,
      "ojt"          ,
     "profit"        ,
      # 基準値
     "first_visit"             ,
     "first_reply"             ,
     "first_interview"          ,   
     "first_full_talk"           ,  
     "first_write"             ,
     "first_get"                ,          
     "latter_visit"             ,
     "latter_reply"             ,
     "latter_interview"          ,   
     "latter_full_talk"           ,  
     "latter_write"             ,
     "latter_get"                ,          
     "night_visit"             ,
     "night_reply"             ,
     "night_interview"          ,   
     "night_full_talk"           ,  
     "night_write"             ,
     "night_get"                ,         

     "existing_visit"             ,
     "existing_interview"          ,   
     "existing_full_talk"           ,  
     "existing_get"                  ,  
    #  訪問内訳      
     "detached_a"                       ,   
     "detached_get"                       ,   
     "apartment_a"                       ,   
     "apartment_get"                       ,   
     "family_apartment_a"                 ,         
     "family_apartment_get"                 ,         
     "auto_single_a"                    ,      
     "auto_single_get"                    ,      
     "auto_family_a"                    ,      
     "auto_family_get"                    ,
           
     "door_take"                          ,
     "easy"                          ,
     "contract_change_interview",
     "contract_change_full_talk",
     "contract_change_get",
     "resum_payment_interview"          ,         
     "resum_payment_full_talk"           ,        
     "resum_payment_get"                  , 
     "catch_call"                  ,
     "catch_interview"              ,    
     "catch_full_talk"               ,   
     "catch_get"                  ,
     "office_visit"                ,  
     "office_interview"             ,     
     "office_full_talk"              ,    
     "office_get"                  ,
      # 商材
     "terrestrial_new"              ,       
     "satellite_new"                 ,    
     "account_new"                    , 
     "credit_new"                     ,
     "terrestrial_transfer"            ,         
     "satellite_transfer"               ,      
     "contract_change"                   ,
     "resum_payment"                   ,
     "resum_payment_account"            ,       
     "resum_payment_num"                 ,  
     "payment_change"                  ,
     "receipt_num"             ,
     "receipt_account"          ,   
     "office"       ,
      # 切り返し      
      # 基本切り返し
     "no_watch_a"    ,   
     "no_watch_b"     ,  
     "no_watch_c"      , 
     "no_watch_get"     ,  
     "not_everyone_a"    ,   
     "not_everyone_b"     ,  
     "not_everyone_c"      , 
     "not_everyone_get"     ,  
     "throw_away_a"       ,
     "throw_away_b"       ,
     "throw_away_c"       ,
     "throw_away_get"      , 
     "suddenly_a"       ,
     "suddenly_b"       ,
     "suddenly_c"       ,
     "suddenly_get"      , 
     "another_contract_a"  ,     
     "another_contract_b"   ,    
     "another_contract_c"    ,   
     "another_contract_get"   ,    
     "no_thank_you_a"       ,
     "no_thank_you_b"       ,
     "no_thank_you_c"       ,
     "no_thank_you_get"      , 
     "late_night_a"       ,
     "late_night_b"       ,
     "late_night_c"       ,
     "late_night_get"      , 
      # 先延ばし
     "busy_a"       ,
     "busy_b"       ,
     "busy_c"       ,
     "busy_get"      , 
     "do_it_a"       ,
     "do_it_b"       ,
     "do_it_c"       ,
     "do_it_get"      , 
     "think_a"       ,
     "think_b"       ,
     "think_c"       ,
     "think_get"      , 
      # 第三者
     "partner_a"       ,
     "partner_b"       ,
     "partner_c"       ,
     "partner_get"      , 
     "company_a"       ,
     "company_b"       ,
     "company_c"       ,
     "company_get"      , 
     "tudent_a"       ,
     "student_b"       ,
     "student_c"       ,
     "student_get"      , 
      # スキル
     "no_money_a"       ,
     "no_money_b"       ,
     "no_money_c"       ,
     "no_money_get"      , 
     "not_here_a"       ,
     "not_here_b"       ,
     "not_here_c"       ,
     "not_here_get"      , 
     "no_payment_a"       ,
     "o_payment_b"       ,
     "no_payment_c"       ,
     "no_payment_get"      , 
     "foreign_a"       ,
     "foreign_b"       ,
     "foreign_c"       ,
     "foreign_get"      , 
      # その他
     "difficult_deal_a"  ,     
     "difficult_deal_b"   ,    
     "difficult_deal_c"    ,   
     "difficult_deal_get"   ,    
     "past_trouble_a"       ,
     "past_trouble_b"       ,
     "past_trouble_c"       ,
     "past_trouble_get"      , 
     "trial_hope_a"       ,
     "trial_hope_b"       ,
     "trial_hope_c"       ,
     "trial_hope_get"      , 
     "other_a"       ,
     "other_b"       ,
     "other_c"       ,
     "other_get"      , 
     "no_tv_a"       ,
     "no_tv_b"       ,
     "no_tv_c"       ,
     "no_tv_get"      , 
     "no_tv_excavation"      , 
     "no_tv_excavation_ng"    ,   
     "breaking_tv_a"       ,
     "breaking_tv_b"       ,
     "breaking_tv_c"       ,
     "breaking_tv_get"      , 
     "breaking_tv_excavation"   ,    
     "breaking_tv_excavation_ng"  
    ]
  end
end
