class AirpaySticker < ApplicationRecord

  belongs_to :user

  with_options presence: true do 
    validates :form_send_month
    validates :form_send
    validates :category
    validates :customer_num
    validates :valuation
    validates :profit_sticker
    validates :profit_pop
  end 

  def self.import(file)
    detection = CharlockHolmes::EncodingDetector.detect(File.read(file.path))
    encoding = detection[:encoding] == 'Shift_JIS' ? 'CP932' : detection[:encoding]
    new_cnt = 0
    update_cnt = 0
    nochange_cnt = 0
    CSV.foreach(file.path, encoding: "#{encoding}:UTF-8",headers: true) do |row|
    user = User.find_by(name: row["AC対応者"])
    airpay = find_by(customer_num: row["店舗番号"])
    if airpay.present? 
      airpay.assign_attributes(
        category: row["カテゴリー"],
        user_id: user.id,
        customer_num: row["店舗番号"],
        store_name: row["店舗名"],
        form_send_month: row["フォーム送信月"],
        form_send: row["フォーム送信日"],
        sticker_ok: row["ステッカー両方OK"],
        pop_ok: row["店頭ポップOK"],
        deficiency: row["不備確認"],
        valuation: row["評価売"],
        profit_sticker: row["ステッカー実売"],
        profit_pop: row["ポップ実売"],
        
      )
      if airpay.has_changes_to_save? 
        airpay.save!
        update_cnt += 1
      else  
        nochange_cnt += 1
      end 
    else  
      airpay = new(
        category: row["カテゴリー"],
        user_id: user.id,
        customer_num: row["店舗番号"],
        store_name: row["店舗名"],
        form_send_month: row["フォーム送信月"],
        form_send: row["フォーム送信日"],
        sticker_ok: row["ステッカー両方OK"],
        pop_ok: row["店頭ポップOK"],
        deficiency: row["不備確認"],
        valuation: row["評価売"],
        profit_sticker: row["ステッカー実売"],
        profit_pop: row["ポップ実売"],
        
        )
      airpay.save!
      new_cnt += 1
    end
  end
  "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件 "
  end

end
