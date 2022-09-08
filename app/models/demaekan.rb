class Demaekan < ApplicationRecord
  belongs_to :user 
  belongs_to :store_prop

  with_options presence: true do 
    validates :user_id 
    validates :store_prop_id
    validates :date
    validates :status
    validates :profit
    validates :valuation

  end 
  # データが問題ないかチェックする関数
  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      store_prop = StoreProp.find_by(mail_1: row["契約者メールアドレス"],city: row["市区"])
      user = User.find_by(name: row["獲得者"])
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
        store_id = store_prop.id if store_prop.present?
        demaekan = new(
          status: row["簡易ステータス"],
          user_id: user.id,
          store_prop_id: store_id,
          date: row["タイムスタンプ"],
          customer_num: row["案件NO"],
          cs_send: row["初回CS送信日"],
          first_cs_contract: row["初回CS締結日"],
          deadline: row["締結期限"],
          profit: 25000,
          valuation: 7000
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if demaekan.invalid? && errors.length < 5
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
    user = User.find_by(name: row["獲得者"])
    store_prop = StoreProp.find_by(mail_1: row["契約者メールアドレス"],city: row["市区"])
    store_id = store_prop.id if store_prop.present?
    demaekan = find_by(customer_num: row["案件NO"])
    if demaekan.present? 
      demaekan.assign_attributes(
        status: row["簡易ステータス"],
        user_id: user.id,
        store_prop_id: store_id,
        date: row["タイムスタンプ"],
        customer_num: row["案件NO"],
        cs_send: row["初回CS送信日"],
        first_cs_contract: row["初回CS締結日"],
        deadline: row["締結期限"],
        profit: 25000,
        valuation: 7000
      )
      if demaekan.has_changes_to_save? 
        demaekan.save!
        update_cnt += 1
      else  
        nochange_cnt += 1
      end 
    else  
      demaekan = new(
        status: row["簡易ステータス"],
        user_id: user.id,
        store_prop_id: store_id,
        date: row["タイムスタンプ"],
        customer_num: row["案件NO"],
        cs_send: row["初回CS送信日"],
        first_cs_contract: row["初回CS締結日"],
        deadline: row["締結期限"],
        profit: 25000,
        valuation: 7000
        )
      demaekan.save!
      new_cnt += 1
    end
  end
  "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件 "
  end
end
