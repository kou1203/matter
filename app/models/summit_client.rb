class SummitClient < ApplicationRecord
  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      summit_unique = Summit.find_by(record_num: row["拠点情報_レコード番号"])
      errors << "#{index}行目のレコード番号が存在しません。#{row["拠点情報_レコード番号"]}" if summit_unique.blank? && errors.length < 5
      s_id = summit_unique.id if summit_unique.present? 
        summit = new(
          summit_id: s_id,
          start_use: row["開始希望日"],
          supply_num: row["供給地点特定番号"],
          pay_menu: row["料金メニュー"],
          remarks: row["備考"],
          create_date: row["作成日時"],
          update_date: row["更新日時"],
          target_record_num: row["対象案件一覧_レコード番号"],
          novice_menu: row["ノービスメニュー"],
          rate: row["報酬率"],
          cancel: row["SECIP(解約申込)-異動日"],
          cancel_status: row["SECIP(解約申込)-申込ステータス"],
          cancel_app_company: row["SECIP(解約申込)-小売事業者名称（SW）"],
          error_contents: row["SECIP(開始申込)-エラー内容"],
          crepiko_num: row["クレピコお客様番号"]
        )
        errors << "#{index}行目,屋号名「#{row["屋号名"]}」保存できませんでした" if summit.invalid? && errors.length < 5
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
    summit = find_by(record_num: row["拠点情報_レコード番号"])
    if summit.present? 
      summit.assign_attributes(
        summit_id: s_id,
        start_use: row["開始希望日"],
        supply_num: row["供給地点特定番号"],
        pay_menu: row["料金メニュー"],
        remarks: row["備考"],
        create_date: row["作成日時"],
        update_date: row["更新日時"],
        target_record_num: row["対象案件一覧_レコード番号"],
        novice_menu: row["ノービスメニュー"],
        rate: row["報酬率"],
        cancel: row["SECIP(解約申込)-異動日"],
        cancel_status: row["SECIP(解約申込)-申込ステータス"],
        cancel_app_company: row["SECIP(解約申込)-小売事業者名称（SW）"],
        error_contents: row["SECIP(開始申込)-エラー内容"],
        crepiko_num: row["クレピコお客様番号"]
      )
      if summit.has_changes_to_save? 
        summit.save!
        summit.assign_attributes(status_update: Date.today)
        update_cnt += 1
      else  
        nochange_cnt += 1
      end 
    else  
      summit = new(
        summit_id: summit_id,
        start_use: row["開始希望日"],
        supply_num: row["供給地点特定番号"],
        pay_menu: row["料金メニュー"],
        remarks: row["備考"],
        create_date: row["作成日時"],
        update_date: row["更新日時"],
        target_record_num: row["対象案件一覧_レコード番号"],
        novice_menu: row["ノービスメニュー"],
        rate: row["報酬率"],
        cancel: row["SECIP(解約申込)-異動日"],
        cancel_status: row["SECIP(解約申込)-申込ステータス"],
        cancel_app_company: row["SECIP(解約申込)-小売事業者名称（SW）"],
        error_contents: row["SECIP(開始申込)-エラー内容"],
        crepiko_num: row["クレピコお客様番号"]
        )
      summit.save!
      new_cnt += 1
    end
  end
  "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件 "
  end
end
