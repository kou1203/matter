class CreateResultCashes < ActiveRecord::Migration[6.1]
  def change
    create_table :result_cashes do |t|
    # キャッシュレス
      # どういうこと？
      t.references :result , foreign_key: true 
      t.integer :what_interview      
      t.integer :what_full_talk      
      t.integer :what_get            
      # 君は誰？
      t.integer :who_interview      
      t.integer :who_full_talk      
      t.integer :who_get            
      # もらうだけ？
      t.integer :just_get_interview      
      t.integer :just_get_full_talk      
      t.integer :just_get_get            
      # PayPayのみ
      t.integer :paypay_only_interview      
      t.integer :paypay_only_full_talk      
      t.integer :paypay_only_get            
      # エアペイのみ
      t.integer :airpay_only_interview      
      t.integer :airpay_only_full_talk      
      t.integer :airpay_only_get      
      # カードのみ      
      t.integer :card_only_interview      
      t.integer :card_only_full_talk      
      t.integer :card_only_get           
      # 先延ばし 
      t.integer :yet_interview      
      t.integer :yet_full_talk      
      t.integer :yet_get       
      # 現金のみ     
      t.integer :cash_only_interview      
      t.integer :cash_only_full_talk      
      t.integer :cash_only_get           
      # 忙しい 
      t.integer :busy_interview      
      t.integer :busy_full_talk      
      t.integer :busy_get    
      # めんどくさい        
      t.integer :dull_interview      
      t.integer :dull_full_talk      
      t.integer :dull_get            
      # 情報不足
      t.integer :lack_info_interview      
      t.integer :lack_info_full_talk      
      t.integer :lack_info_get            
      # ぺろ
      t.integer :easy_interview      
      t.integer :easy_full_talk      
      t.integer :easy_get   
      # その他
      t.integer :other_interview      
      t.integer :other_full_talk      
      t.integer :other_get    
    end
  end
end
