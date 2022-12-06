class SummitPrice < ApplicationRecord
  belongs_to :summit
  
  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      summit = Summit.find_by(record_num: row["レコード番号"])
      s_id = summit.id rescue ""
        price = new(
          first_billing: row["月間予想売上"],
          last_billing: row["実請求分加味\n月間予想売上"],
          summit_id: s_id,
          record_num: row["レコード番号"],
        )
        errors << "#{index}行目,レコード番号「#{row["レコード番号"]}」保存できませんでした" if price.invalid? && errors.length < 5
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
      summit = Summit.find_by(record_num: row["レコード番号"])
      s_id = summit.id rescue ""
      summit_price = SummitPrice.find_by(record_num: row["レコード番号"])
    if summit_price.present? 
      summit_price.assign_attributes(
        first_billing: row["月間予想売上"],
        last_billing: row["実請求分加味\n月間予想売上"],
        summit_id: s_id,
        record_num: row["レコード番号"],
      )
      if summit_price.has_changes_to_save? 
        summit_price.save!
        update_cnt += 1
      else  
        nochange_cnt += 1
      end 
    else  
      summit_price = new(
        first_billing: row["月間予想売上"],
        last_billing: row["実請求分加味\n月間予想売上"],
        summit_id: s_id,
        record_num: row["レコード番号"],
        )
        summit_price.save!
      new_cnt += 1
    end
  end
  "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件 "
  end
end
