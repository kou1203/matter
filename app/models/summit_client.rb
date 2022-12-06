class SummitClient < ApplicationRecord
  belongs_to :summit

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      summit_unique = Summit.find_by(record_num: row["拠点情報_レコード番号"])
      errors << "#{index}行目のレコード番号が存在しません。#{row["拠点情報_レコード番号"]}" if summit_unique.blank? && errors.length < 5
      s_id = summit_unique.id if summit_unique.present? 
        summit = new(
          summit_id: s_id,
          area: row["電力エリア"],
          start_use: row["開始希望日"],
          change_date: row["SECIP(開始申込)-異動日"],
          supply_num: row["供給地点特定番号"],
          store_name: row["契約者ー法人名（漢字）"],
          low_voltage_contract_id: row["電力営業(需要家実績)-低圧需要家契約ID"],
          pay_menu: row["料金メニュー"],
          remarks: row["備考"],
          summit_manger: row["サミット事務担当"],
          create_date: row["作成日時"],
          update_date: row["更新日時"],
          target_record_num: row["対象案件一覧_レコード番号"],
          updater: row["更新者"],
          creater: row["作成者"],
          contact_num: row["電力営業(需要家実績)-請求先ID(お客様番号／お問い合わせ番号)"],
          novice_menu: row["ノービスメニュー"],
          start_status: row["SECIP(開始申込)-申込ステータス"],
          start_cancel_status: row["SECIP(開始申込)-キャンセルステータス"],
          agency_status: row["SECIP(開始申込)-廃止取次ステータス"],
          contract_start: row["SECIP(需要家管理)-契約開始日"],
          contract_end: row["SECIP(需要家管理)-契約終了日"],
          customer_name: row["SECIP(開始申込)-需要家名(漢字)(託送)"],
          rate: row["報酬率"],
          salesman_partner_id: row["電力営業(需要家実績)-営業担当先ID"],
          salesman_user_id: row["電力営業(需要家実績)-営業担当ユーザID"],
          partner_name: row["電力営業(需要家実績)-提携先サイト名称"],
          contract_partner: row["電力営業(需要家実績)-提携先自由項目1(請求書記載名称)"],
          contact_name: row["電力営業-連絡先_担当者_名称"],
          contact_phone: row["電力営業-連絡先_電話_番号"],
          contact_mail: row["電力営業-連絡先_メール_アドレス"],
          salesman: row["担当営業(氏名)"],
          start_app_company: row["SECIP(開始申込)-小売事業者名称（SW）"],
          cancel_class: row["SECIP(解約申込)-申込種別"],
          cancel_status: row["SECIP(解約申込)-申込ステータス"],
          cancel: row["SECIP(解約申込)-異動日"],
          cancel_app_company: row["SECIP(解約申込)-小売事業者名称（SW）"],
          start_company_contract_num: row["SECIP(開始申込)-現小売事業者契約番号"],
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
      summit_unique = Summit.find_by(record_num: row["拠点情報_レコード番号"])
      s_id = summit_unique.id if summit_unique.present? 
      summit = find_by(summit_id: s_id)
    if summit.present? 
      summit.assign_attributes(
        summit_id: s_id,
        area: row["電力エリア"],
        start_use: row["開始希望日"],
        change_date: row["SECIP(開始申込)-異動日"],
        supply_num: row["供給地点特定番号"],
        store_name: row["契約者ー法人名（漢字）"],
        low_voltage_contract_id: row["電力営業(需要家実績)-低圧需要家契約ID"],
        pay_menu: row["料金メニュー"],
        remarks: row["備考"],
        summit_manger: row["サミット事務担当"],
        create_date: row["作成日時"],
        update_date: row["更新日時"],
        target_record_num: row["対象案件一覧_レコード番号"],
        updater: row["更新者"],
        creater: row["作成者"],
        contact_num: row["電力営業(需要家実績)-請求先ID(お客様番号／お問い合わせ番号)"],
        novice_menu: row["ノービスメニュー"],
        start_status: row["SECIP(開始申込)-申込ステータス"],
        start_cancel_status: row["SECIP(開始申込)-キャンセルステータス"],
        agency_status: row["SECIP(開始申込)-廃止取次ステータス"],
        contract_start: row["SECIP(需要家管理)-契約開始日"],
        contract_end: row["SECIP(需要家管理)-契約終了日"],
        customer_name: row["SECIP(開始申込)-需要家名(漢字)(託送)"],
        rate: row["報酬率"],
        salesman_partner_id: row["電力営業(需要家実績)-営業担当先ID"],
        salesman_user_id: row["電力営業(需要家実績)-営業担当ユーザID"],
        partner_name: row["電力営業(需要家実績)-提携先サイト名称"],
        contract_partner: row["電力営業(需要家実績)-提携先自由項目1(請求書記載名称)"],
        contact_name: row["電力営業-連絡先_担当者_名称"],
        contact_phone: row["電力営業-連絡先_電話_番号"],
        contact_mail: row["電力営業-連絡先_メール_アドレス"],
        salesman: row["担当営業(氏名)"],
        start_app_company: row["SECIP(開始申込)-小売事業者名称（SW）"],
        cancel_class: row["SECIP(解約申込)-申込種別"],
        cancel_status: row["SECIP(解約申込)-申込ステータス"],
        cancel: row["SECIP(解約申込)-異動日"],
        cancel_app_company: row["SECIP(解約申込)-小売事業者名称（SW）"],
        start_company_contract_num: row["SECIP(開始申込)-現小売事業者契約番号"],
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
        summit_id: s_id,
        area: row["電力エリア"],
        start_use: row["開始希望日"],
        change_date: row["SECIP(開始申込)-異動日"],
        supply_num: row["供給地点特定番号"],
        store_name: row["契約者ー法人名（漢字）"],
        low_voltage_contract_id: row["電力営業(需要家実績)-低圧需要家契約ID"],
        pay_menu: row["料金メニュー"],
        remarks: row["備考"],
        summit_manger: row["サミット事務担当"],
        create_date: row["作成日時"],
        update_date: row["更新日時"],
        target_record_num: row["対象案件一覧_レコード番号"],
        updater: row["更新者"],
        creater: row["作成者"],
        contact_num: row["電力営業(需要家実績)-請求先ID(お客様番号／お問い合わせ番号)"],
        novice_menu: row["ノービスメニュー"],
        start_status: row["SECIP(開始申込)-申込ステータス"],
        start_cancel_status: row["SECIP(開始申込)-キャンセルステータス"],
        agency_status: row["SECIP(開始申込)-廃止取次ステータス"],
        contract_start: row["SECIP(需要家管理)-契約開始日"],
        contract_end: row["SECIP(需要家管理)-契約終了日"],
        customer_name: row["SECIP(開始申込)-需要家名(漢字)(託送)"],
        rate: row["報酬率"],
        salesman_partner_id: row["電力営業(需要家実績)-営業担当先ID"],
        salesman_user_id: row["電力営業(需要家実績)-営業担当ユーザID"],
        partner_name: row["電力営業(需要家実績)-提携先サイト名称"],
        contract_partner: row["電力営業(需要家実績)-提携先自由項目1(請求書記載名称)"],
        contact_name: row["電力営業-連絡先_担当者_名称"],
        contact_phone: row["電力営業-連絡先_電話_番号"],
        contact_mail: row["電力営業-連絡先_メール_アドレス"],
        salesman: row["担当営業(氏名)"],
        start_app_company: row["SECIP(開始申込)-小売事業者名称（SW）"],
        cancel_class: row["SECIP(解約申込)-申込種別"],
        cancel_status: row["SECIP(解約申込)-申込ステータス"],
        cancel: row["SECIP(解約申込)-異動日"],
        cancel_app_company: row["SECIP(解約申込)-小売事業者名称（SW）"],
        start_company_contract_num: row["SECIP(開始申込)-現小売事業者契約番号"],
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
