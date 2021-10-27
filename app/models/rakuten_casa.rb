class RakutenCasa < ApplicationRecord
  belongs_to :user
  belongs_to :putter, class_name: "User", optional: true
  belongs_to :adjustmenter, class_name: "User", optional: true
  belongs_to :store_prop

  with_options presence: true do 
    validates :client 
    validates :user_id 
    validates :store_prop_id 
    validates :date
    validates :status
    validates :net_confirm_method
    validates :net_name
    validates :hikari_collabo
    validates :net_plan
    validates :customer_num
    validates :net_contracter
    validates :net_contracter_kana
    validates :net_phone_number
    validates :net_address
    validates :profit_new
    validates :profit_put  
    validates :valuation_new  
    validates :valuation_put  
  end
  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"])
      putter = User.find_by(name: row["設置者"])
      p_id = 
      if putter.present?
        putter.id
      else  
        row["設置者"]
      end
      adjustmenter = User.find_by(name: row["システム調整対応者"])
      a_id = 
      if adjustmenter.present?
        adjustmenter.id
      else  
        row["システム調整対応者"]
      end
      u_id = user.id if user.present?
      store_prop = StoreProp.find_by(name: row["店舗名"])
      errors << "#{index}行目獲得者が不正です" if user.blank?
      errors << "#{index}行目店舗名が不正です" if store_prop.blank?
      if row["ID"].present?
        rakuten_casa = find_by(id: row["ID"])
        errors << "#{index}行目 IDが不適切です" if rakuten_casa.blank?
      else  
        store_id = store_prop.id if store_prop.present?
        rakuten_casa = new(
          id: row["ID"],
          store_prop_id: store_id,
          client: row["商流"],
          user_id: u_id,
          date: row["獲得日"],
          status: row["現状ステータス"],
          status_update: row["ステータス更新日"],
          net_confirm_method: row["回線確認方法"],
          net_name: row["回線事業者"],
          hikari_collabo: row["光コラボ"],
          net_plan: row["回線プラン名"],
          customer_num: row["回線ID"],
          net_address: row["設置住所"],
          net_contracter: row["回線契約者名"],
          net_contracter_kana: row["回線契約者名（カナ）"],
          net_phone_number: row["回線登録連絡先"],
          remarks: row["備考"],
          share: row["上位店共有日"],
          # 自社不備
          deficiency: row["自社不備発生日"],
          status_deficiency: row["自社不備ステータス"],
          deficiency_remarks: row["自社不備内容"],
          deficiency_solution: row["自社不備解消日"],
          # 回線不備
          deficiency_net: row["回線初回不備発生日"],
          status_deficiency_net: row["回線不備分類"],
          deficiency_share_net: row["回線不備共有日"],
          deficiency_last_shared_net: row["回線不備前回共有日"],
          deficiency_result_net: row["回線不備対応結果"],
          deficiency_remarks_net: row["回線不備詳細"],
          deficiency_solution_net: row["回線不備解消日"],
          # 反社不備
          deficiency_anti: row["反社初回不備発生日"],
          status_deficiency_anti: row["反社不備分類"],
          deficiency_share_anti: row["反社不備共有日"],
          deficiency_last_shared_anti: row["反社不備前回共有日"],
          deficiency_result_anti: row["反社不備対応結果"],
          deficiency_remarks_anti: row["反社不備詳細"],
          deficiency_solution_anti: row["反社不備解消日"],
          # 端末情報
          order: row["発注日"],
          arrival: row["納品日"],
          femto_id: row["FemtoID"],
          inspection: row["検品"],
          done_oss: row["OSS登録日"],
          # 設置
          put_plan: row["設置予定日"],
          put: row["設置日"],
          putter_id: p_id,
          radio_waves: row["電波観測"],
          google_form_share: row["GoogleForm（設置）"],
          status_put: row["設置ステータス"],
          # 図書
          share_book: row["竣工図書提出日"],
          status_book: row["竣工図書ステータス"],
          deficiency_book: row["竣工図書不備発生日"],
          deficiency_remarks_book: row["竣工図書不備詳細"],
          deficiency_result_book: row["竣工図書不備対応結果"],
          deficiency_solution_book: row["竣工図書不備解消日"],
          done_book: row["竣工図書承認日"],
          # 未完図書
          share_undone_book: row["未完図書提出日"],
          status_undone_book: row["未完図書ステータス"],
          deficiency_solution_undone_book: row["未完図書不備解消日"],
          done_undone_book: row["未完図書承認日"],
          # システム調整
          radio_waves_undone: row["未完後電波観測"],
          put_adjustment: row["システム調整設置日"],
          adjustmenter_id: a_id,
          share_adjustment: row["システム調整提出日"],
          deficiency_adjustment: row["システム調整不備発生日"],
          deficiency_solution_adjustment: row["システム調整不備解消日"],
          google_form_share_adjustment: row["GoogleFrom（システム調整）"],
          adjustment_status: row["システム調整ステータス"],
          done_adjustment: row["調整図書受理日"],
          # 申込書
          share_app: row["申込書提出日"],
          app_create: row["申込書作成日"],
          status_app: row["申込ステータス"],
          done_app: row["申込書楽天受理日"],
          # 覚書
          share_memo: row["覚書提出日"],
          memo_create: row["覚書作成日"],
          status_memo: row["覚書ステータス"],
          done_memo: row["覚書楽天受理日"],
          letter_pack_num1: row["レターパック追跡番号①"],
          letter_pack_num2: row["レターパック追跡番号②"],
          # 成果地点、入金日
          payment: row["新規入金日"],
          payment_put: row["設置入金日"],
          profit_new: row["新規評価売上"],
          profit_put: row["設置評価売上"],
          valuation_new: row["新規実売上"],
          valuation_put: row["設置実売上"]
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if rakuten_casa.invalid?
      end
    end
    errors
  end

  def self.import(file)
    new_cnt = 0
    update_cnt = 0
    nochange_cnt = 0
    CSV.foreach(file.path, headers: true) do |row|
      user = User.find_by(name: row["獲得者"])
      store_prop = StoreProp.find_by(name: row["店舗名"])
      u_id = user.id if user.present?
      putter = User.find_by(name: row["設置者"])
      p_id = 
      if putter.present?
        putter.id
      else  
        row["設置者"]
      end
      adjustmenter = User.find_by(name: row["システム調整対応者"])
      a_id = 
      if adjustmenter.present?
        adjustmenter.id
      else  
        row["システム調整対応者"]
      end
      store_id = store_prop.id if store_prop.present?
      rakuten_casa = find_by(store_prop_id:  store_prop.id)
      if store_prop.rakuten_casa.present?
        rakuten_casa.assign_attributes(
          store_prop_id: store_id,
          client: row["商流"],
          user_id: u_id,
          date: row["獲得日"],
          status: row["現状ステータス"],
          status_update: row["ステータス更新日"],
          net_confirm_method: row["回線確認方法"],
          net_name: row["回線事業者"],
          hikari_collabo: row["光コラボ"],
          net_plan: row["回線プラン名"],
          customer_num: row["回線ID"],
          net_address: row["設置住所"],
          net_contracter: row["回線契約者名"],
          net_contracter_kana: row["回線契約者名（カナ）"],
          net_phone_number: row["回線登録連絡先"],
          remarks: row["備考"],
          share: row["上位店共有日"],
          # 自社不備
          deficiency: row["自社不備発生日"],
          status_deficiency: row["自社不備ステータス"],
          deficiency_remarks: row["自社不備内容"],
          deficiency_solution: row["自社不備解消日"],
          # 回線不備
          deficiency_net: row["回線初回不備発生日"],
          status_deficiency_net: row["回線不備分類"],
          deficiency_share_net: row["回線不備共有日"],
          deficiency_last_shared_net: row["回線不備前回共有日"],
          deficiency_result_net: row["回線不備対応結果"],
          deficiency_remarks_net: row["回線不備詳細"],
          deficiency_solution_net: row["回線不備解消日"],
          # 反社不備
          deficiency_anti: row["反社初回不備発生日"],
          status_deficiency_anti: row["反社不備分類"],
          deficiency_share_anti: row["反社不備共有日"],
          deficiency_last_shared_anti: row["反社不備前回共有日"],
          deficiency_result_anti: row["反社不備対応結果"],
          deficiency_remarks_anti: row["反社不備詳細"],
          deficiency_solution_anti: row["反社不備解消日"],
          # 端末情報
          order: row["発注日"],
          arrival: row["納品日"],
          femto_id: row["FemtoID"],
          inspection: row["検品"],
          done_oss: row["OSS登録日"],
          # 設置
          put_plan: row["設置予定日"],
          put: row["設置日"],
          putter_id: p_id,
          radio_waves: row["電波観測"],
          google_form_share: row["GoogleForm（設置）"],
          status_put: row["設置ステータス"],
          # 図書
          share_book: row["竣工図書提出日"],
          status_book: row["竣工図書ステータス"],
          deficiency_book: row["竣工図書不備発生日"],
          deficiency_remarks_book: row["竣工図書不備詳細"],
          deficiency_result_book: row["竣工図書不備対応結果"],
          deficiency_solution_book: row["竣工図書不備解消日"],
          done_book: row["竣工図書承認日"],
          # 未完図書
          share_undone_book: row["未完図書提出日"],
          status_undone_book: row["未完図書ステータス"],
          deficiency_solution_undone_book: row["未完図書不備解消日"],
          done_undone_book: row["未完図書承認日"],
          # システム調整
          radio_waves_undone: row["未完後電波観測"],
          put_adjustment: row["システム調整設置日"],
          adjustmenter_id: a_id,
          share_adjustment: row["システム調整提出日"],
          deficiency_adjustment: row["システム調整不備発生日"],
          deficiency_solution_adjustment: row["システム調整不備解消日"],
          google_form_share_adjustment: row["GoogleFrom（システム調整）"],
          adjustment_status: row["システム調整ステータス"],
          done_adjustment: row["調整図書受理日"],
          # 申込書
          share_app: row["申込書提出日"],
          app_create: row["申込書作成日"],
          status_app: row["申込ステータス"],
          done_app: row["申込書楽天受理日"],
          # 覚書
          share_memo: row["覚書提出日"],
          memo_create: row["覚書作成日"],
          status_memo: row["覚書ステータス"],
          done_memo: row["覚書楽天受理日"],
          letter_pack_num1: row["レターパック追跡番号①"],
          letter_pack_num2: row["レターパック追跡番号②"],
          # 成果地点、入金日
          payment: row["新規入金日"],
          payment_put: row["設置入金日"],
          profit_new: row["新規評価売上"],
          profit_put: row["設置評価売上"],
          valuation_new: row["新規実売上"],
          valuation_put: row["設置実売上"]
        )
        if rakuten_casa.has_changes_to_save? 
          rakuten_casa.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        rakuten_casa = new(
          id: row["ID"],
          store_prop_id: store_id,
          client: row["商流"],
          user_id: u_id,
          date: row["獲得日"],
          status: row["現状ステータス"],
          status_update: row["ステータス更新日"],
          net_confirm_method: row["回線確認方法"],
          net_name: row["回線事業者"],
          hikari_collabo: row["光コラボ"],
          net_plan: row["回線プラン名"],
          customer_num: row["回線ID"],
          net_address: row["設置住所"],
          net_contracter: row["回線契約者名"],
          net_contracter_kana: row["回線契約者名（カナ）"],
          net_phone_number: row["回線登録連絡先"],
          remarks: row["備考"],
          share: row["上位店共有日"],
          # 自社不備
          deficiency: row["自社不備発生日"],
          status_deficiency: row["自社不備ステータス"],
          deficiency_remarks: row["自社不備内容"],
          deficiency_solution: row["自社不備解消日"],
          # 回線不備
          deficiency_net: row["回線初回不備発生日"],
          status_deficiency_net: row["回線不備分類"],
          deficiency_share_net: row["回線不備共有日"],
          deficiency_last_shared_net: row["回線不備前回共有日"],
          deficiency_result_net: row["回線不備対応結果"],
          deficiency_remarks_net: row["回線不備詳細"],
          deficiency_solution_net: row["回線不備解消日"],
          # 反社不備
          deficiency_anti: row["反社初回不備発生日"],
          status_deficiency_anti: row["反社不備分類"],
          deficiency_share_anti: row["反社不備共有日"],
          deficiency_last_shared_anti: row["反社不備前回共有日"],
          deficiency_result_anti: row["反社不備対応結果"],
          deficiency_remarks_anti: row["反社不備詳細"],
          deficiency_solution_anti: row["反社不備解消日"],
          # 端末情報
          order: row["発注日"],
          arrival: row["納品日"],
          femto_id: row["FemtoID"],
          inspection: row["検品"],
          done_oss: row["OSS登録日"],
          # 設置
          put_plan: row["設置予定日"],
          put: row["設置日"],
          putter_id: p_id,
          radio_waves: row["電波観測"],
          google_form_share: row["GoogleForm（設置）"],
          status_put: row["設置ステータス"],
          # 図書
          share_book: row["竣工図書提出日"],
          status_book: row["竣工図書ステータス"],
          deficiency_book: row["竣工図書不備発生日"],
          deficiency_remarks_book: row["竣工図書不備詳細"],
          deficiency_result_book: row["竣工図書不備対応結果"],
          deficiency_solution_book: row["竣工図書不備解消日"],
          done_book: row["竣工図書承認日"],
          # 未完図書
          share_undone_book: row["未完図書提出日"],
          status_undone_book: row["未完図書ステータス"],
          deficiency_solution_undone_book: row["未完図書不備解消日"],
          done_undone_book: row["未完図書承認日"],
          # システム調整
          radio_waves_undone: row["未完後電波観測"],
          put_adjustment: row["システム調整設置日"],
          adjustmenter_id: a_id,
          share_adjustment: row["システム調整提出日"],
          deficiency_adjustment: row["システム調整不備発生日"],
          deficiency_solution_adjustment: row["システム調整不備解消日"],
          google_form_share_adjustment: row["GoogleFrom（システム調整）"],
          adjustment_status: row["システム調整ステータス"],
          done_adjustment: row["調整図書受理日"],
          # 申込書
          share_app: row["申込書提出日"],
          app_create: row["申込書作成日"],
          status_app: row["申込ステータス"],
          done_app: row["申込書楽天受理日"],
          # 覚書
          share_memo: row["覚書提出日"],
          memo_create: row["覚書作成日"],
          status_memo: row["覚書ステータス"],
          done_memo: row["覚書楽天受理日"],
          letter_pack_num1: row["レターパック追跡番号①"],
          letter_pack_num2: row["レターパック追跡番号②"],
          # 成果地点、入金日
          payment: row["新規入金日"],
          payment_put: row["設置入金日"],
          profit_new: row["新規評価売上"],
          profit_put: row["設置評価売上"],
          valuation_new: row["新規実売上"],
          valuation_put: row["設置実売上"]
          )
        rakuten_casa.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
