class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.references :user             , foreign_key: true
      t.date :date                      , null: false
      t.string :area                    , null: false 
      t.string :shift                    , null: false 
      t.references :ojt 
# 前半
      t.integer :first_visit             
      t.integer :first_interview         
      t.integer :first_full_talk         
      t.integer :first_get               
# 後半
      t.integer :latter_visit            
      t.integer :latter_interview        
      t.integer :latter_full_talk        
      t.integer :latter_get              
# 店舗別基準値（訪問-獲得）
      # 喫茶・カフェ
      t.integer :cafe_visit          
      t.integer :cafe_get            
      # その他・飲食
      t.integer :other_food_visit              
      t.integer :other_food_get            
      # 車屋
      t.integer :car_visit              
      t.integer :car_get            
      # その他小売
      t.integer :other_retail_visit          
      t.integer :other_retail_get            
      # 理容・美容
      t.integer :hair_salon_visit          
      t.integer :hair_salon_get            
      # 整体・鍼灸
      t.integer :manipulative_visit          
      t.integer :manipulative_get       
      # その他・サービス     
      t.integer :other_service_visit              
      t.integer :other_service_get
    end
    add_foreign_key :results,:users, column: :ojt_id
  end
end
