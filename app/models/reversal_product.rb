class ReversalProduct < ApplicationRecord
  belongs_to :user

  with_options presence: true do 
    validates :controll_num
    validates :product
    validates :store_name
    validates :user_id
    validates :date
    validates :result_date
    validates :reversal_date
    validates :price
  end 


  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"]) rescue ""
      errors << "#{index}行目獲得者#{row["獲得者"]}が不正です" if user.blank? && errors.length < 2
        u_id = user.id if user.present? && errors.length < 2
        product = new(
          controll_num: row["管理番号"],
          product: row["商材名"],
          store_name: row["店舗名"],
          user_id: u_id,
          date: row["獲得日"],
          result_date: row["成果になった日"],
          reversal_date: row["戻入日"],
          price: row["評価売"]
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした。入力漏れがないか確認してください。" if product.invalid? && errors.length < 2
    end
    errors
  end

  def self.import(file)
    new_cnt = 0
    update_cnt = 0
    nochange_cnt = 0
    CSV.foreach(file.path, headers: true) do |row|
      user = User.find_by(name: row["獲得者"])
      u_id = user.id if user.present?
      product = find_by(controll_num: row["管理番号"])
      if product.present?
        product.assign_attributes(
          controll_num: row["管理番号"],
          product: row["商材名"],
          store_name: row["店舗名"],
          user_id: u_id,
          date: row["獲得日"],
          result_date: row["成果になった日"],
          reversal_date: row["戻入日"],
          price: row["評価売"]
        )
        if product.has_changes_to_save? 
          product.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        product = new(
          controll_num: row["管理番号"],
          product: row["商材名"],
          store_name: row["店舗名"],
          user_id: u_id,
          date: row["獲得日"],
          result_date: row["成果になった日"],
          reversal_date: row["戻入日"],
          price: row["評価売"]
          )
        product.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
