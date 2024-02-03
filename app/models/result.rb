class Result < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :user
  belongs_to :ojt ,class_name: "User", optional: true
  has_one :result_casa
  has_one :result_cash, dependent: :destroy
  has_one :type_reference_value, dependent: :destroy
  has_one :result_summit, dependent: :destroy
  with_options presence: true do 
    validates :user_id
    validates :date 
    validates :area
    validates :shift
  end

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["ユーザー名"])
      errors << "ユーザー名が不正です" if user.blank? && errors.length < 5
        u_id = user.id if user.present?
        result = new(
          user_id: u_id,
          date: row["日付"],
          area: row["エリア"],
          shift: row["シフト"],
          # 前半
          first_visit: row["前半訪問"],
          first_interview: row["前半対面"] ,
          first_full_talk: row["前半フル"], 
          first_get: row["前半獲得"],       
          # 後半 
          latter_visit: row["後半訪問"],     
          latter_interview: row["後半対面"], 
          latter_full_talk: row["後半フル"], 
          latter_get: row["後半獲得"],       
        # 店舗別基準値
          # 喫茶・カフェ
          cafe_visit: row["喫茶カフェ訪問"],          
          cafe_get: row["喫茶カフェ獲得"],            
          # その他・飲食
          other_food_visit: row["その他飲食訪問"],             
          other_food_get: row["その他飲食獲得"]       ,     
          car_visit: row["車屋訪問"]          ,
          car_get: row["車屋獲得"]            ,
          other_retail_visit: row["その他小売訪問"]  ,        
          other_retail_get:   row["その他小売獲得"]         ,
          hair_salon_visit: row["美容理容訪問"]          ,
          hair_salon_get:   row["美容理容獲得"]         ,
          manipulative_visit: row["整体鍼灸訪問"]         , 
          manipulative_get:   row["整体鍼灸獲得"]         ,
          other_service_visit: row["その他サービス訪問"]         ,
          other_service_get:   row["その他サービス獲得"]
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if result.invalid? && errors.length < 5
    end
    errors
  end

  def self.import(file)
    detection = CharlockHolmes::EncodingDetector.detect(File.read(file.path))
    encoding = detection[:encoding] == 'Shift_JIS' ? 'CP932' : detection[:encoding]
    new_cnt = 0
    update_cnt = 0
    nochange_cnt = 0
    CSV.foreach(file.path, encoding: "#{encoding}:UTF-8",headers: true) do |row|
      user = User.find_by(name: row["ユーザー名"])
      u_id = user.id if user.present?
      result = find_by(user_id:  u_id,date: row["日付"])
      if result.present? 
        result.assign_attributes(
          user_id: u_id,
          date: row["日付"],
          area: row["エリア"],
          shift: row["シフト"],
          # 前半
          first_visit: row["前半訪問"],
          first_interview: row["前半対面"] ,
          first_full_talk: row["前半フル"], 
          first_get: row["前半獲得"],       
          # 後半 
          latter_visit: row["後半訪問"],     
          latter_interview: row["後半対面"], 
          latter_full_talk: row["後半フル"], 
          latter_get: row["後半獲得"],       
          # 店舗別基準値
          cafe_visit: row["喫茶カフェ訪問"],          
          cafe_get: row["喫茶カフェ獲得"],            
          other_food_visit: row["その他飲食訪問"],             
          other_food_get: row["その他飲食獲得"]       ,     
          car_visit: row["車屋訪問"]          ,
          car_get: row["車屋獲得"]            ,
          other_retail_visit: row["その他小売訪問"]  ,        
          other_retail_get:   row["その他小売獲得"]         ,
          hair_salon_visit: row["美容理容訪問"]          ,
          hair_salon_get:   row["美容理容獲得"]         ,
          manipulative_visit: row["整体鍼灸訪問"]         , 
          manipulative_get:   row["整体鍼灸獲得"]         ,
          other_service_visit: row["その他サービス訪問"]         ,
          other_service_get:   row["その他サービス獲得"]
        )
        if result.has_changes_to_save? 
          result.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        result = new(
          user_id: u_id,
          date: row["日付"],
          area: row["エリア"],
          shift: row["シフト"],
          # 前半
          first_visit: row["前半訪問"],
          first_interview: row["前半対面"] ,
          first_full_talk: row["前半フル"], 
          first_get: row["前半獲得"],       
          # 後半 
          latter_visit: row["後半訪問"],     
          latter_interview: row["後半対面"], 
          latter_full_talk: row["後半フル"], 
          latter_get: row["後半獲得"],       
          # 店舗別基準値
          # 喫茶・カフェ
          cafe_visit: row["喫茶カフェ訪問"],          
          cafe_get: row["喫茶カフェ獲得"],            
          # その他・飲食
          other_food_visit: row["その他飲食訪問"],             
          other_food_get: row["その他飲食獲得"]       ,     
          # 車屋
          car_visit: row["車屋訪問"]          ,
          car_get: row["車屋獲得"]            ,
          # その他小売
          other_retail_visit: row["その他小売訪問"]  ,        
          other_retail_get:   row["その他小売獲得"]         ,
          # 美容・理容
          hair_salon_visit: row["美容理容訪問"]          ,
          hair_salon_get:   row["美容理容獲得"]         ,
          # 整体・鍼灸
          manipulative_visit: row["整体鍼灸訪問"]         , 
          manipulative_get:   row["整体鍼灸獲得"]         ,
          # その他・サービス
          other_service_visit: row["その他サービス訪問"]         ,
          other_service_get:   row["その他サービス獲得"]
          )
          result.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
