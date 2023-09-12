class Nuro < ApplicationRecord
  belongs_to :user
  has_many :nuro_payments
  with_options presence: true do 
    validates :controll_num 
    validates :user_id 
    validates :date  
  end 

  def self.csv_check(file)

    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"]) 
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
        u_id = user.id if user.present?
        nuro = new(
          controll_num: row["管理番号"],
          user_id: u_id,
          last_name_kana: row["カナ(姓)"],
          prefecture: row["都道府県市区町村"],
          date: row["お申込日"],
          status: row["現状ステータス"],
          remarks: row["備考"],
          status_after_call: row["後確ステータス"],
          status_progress: row["進捗ステータス"],
          status_antena: row["アンテナ施工ステータス"],
          start: row["開通日"],
          revoke: row["キャンセル日"],
          cancel: row["解約日"],
          current_month_cancel: row["光回線短期解約"],
          option_tell: row["電話サービス同時申込有無"],
          option_hikari_tv: row["ひかりTVサービス開始日(1契約目)"],
          option_hikari_tv2: row["ひかりTVサービス開始日(2契約目)"],
          option_seiton_and_hozon: row["SEITON&HOZON 開始日"],
          option_seiton_and_hozon_cancel: row["SEITON&HOZON キャンセル"],
          option_seiton_and_hozon_flag: row["SEITON&HOZON短期解約"],
          option_nuro_hikari_safe: row["NURO 光 Safe 開始日"],
          option_nuro_hikari_safe_cancel: row["NURO 光 Safe 開始日　キャンセル"],
          option_nuro_hikari_safe_flag: row["NURO 光 Safe短期解約"],
          option_nuro_sakutto_support: row["NURO さくっとサポート 開始日"],
          option_nuro_sakutto_support_cancel: row["NURO さくっとサポート 開始日　キャンセル"],
          option_nuro_sakutto_support_flag: row["NURO さくっとサポート短期解約"],
          option_tokutoku_super: row["とくとくネットスーパー 開始日"],
          option_tokutoku_super_cacnel: row["とくとくネットスーパー 開始日　キャンセル"],
          option_tokutoku_super_flag: row["とくとくネットスーパー短期解約"],
          option_nuro_smart_life: row["NUROスマートライフ 開始日"],
          option_nuro_smart_life_cancel: row["NUROスマートライフ 開始日　キャンセル"],
          option_nuro_smart_life_flag: row["NUROスマートライフ短期解約"],
          option_tsunagaru_mesh_wifi: row["つながるメッシュWi-Fi 開始日"],
          option_tsunagaru_mesh_wifi_cancel: row["つながるメッシュWi-Fi 開始日　キャンセル"],
          option_tsunagaru_mesh_wifi_flag: row["つながるメッシュWi-Fi短期解約"],
          isp_num: row["ISP番号"]
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if nuro.invalid? && errors.length < 5
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
      u_id = user.id if user.present?
      nuro = find_by(controll_num: row["管理番号"])
      if nuro.present?
        nuro.assign_attributes(
          controll_num: row["管理番号"],
          user_id: u_id,
          last_name_kana: row["カナ(姓)"],
          prefecture: row["都道府県市区町村"],
          date: row["お申込日"],
          status: row["現状ステータス"],
          remarks: row["備考"],
          status_after_call: row["後確ステータス"],
          status_progress: row["進捗ステータス"],
          status_antena: row["アンテナ施工ステータス"],
          start: row["開通日"],
          revoke: row["キャンセル日"],
          cancel: row["解約日"],
          current_month_cancel: row["光回線短期解約"],
          option_tell: row["電話サービス同時申込有無"],
          option_hikari_tv: row["ひかりTVサービス開始日(1契約目)"],
          option_hikari_tv2: row["ひかりTVサービス開始日(2契約目)"],
          option_seiton_and_hozon: row["SEITON&HOZON 開始日"],
          option_seiton_and_hozon_cancel: row["SEITON&HOZON キャンセル"],
          option_seiton_and_hozon_flag: row["SEITON&HOZON短期解約"],
          option_nuro_hikari_safe: row["NURO 光 Safe 開始日"],
          option_nuro_hikari_safe_cancel: row["NURO 光 Safe 開始日　キャンセル"],
          option_nuro_hikari_safe_flag: row["NURO 光 Safe短期解約"],
          option_nuro_sakutto_support: row["NURO さくっとサポート 開始日"],
          option_nuro_sakutto_support_cancel: row["NURO さくっとサポート 開始日　キャンセル"],
          option_nuro_sakutto_support_flag: row["NURO さくっとサポート短期解約"],
          option_tokutoku_super: row["とくとくネットスーパー 開始日"],
          option_tokutoku_super_cacnel: row["とくとくネットスーパー 開始日　キャンセル"],
          option_tokutoku_super_flag: row["とくとくネットスーパー短期解約"],
          option_nuro_smart_life: row["NUROスマートライフ 開始日"],
          option_nuro_smart_life_cancel: row["NUROスマートライフ 開始日　キャンセル"],
          option_nuro_smart_life_flag: row["NUROスマートライフ短期解約"],
          option_tsunagaru_mesh_wifi: row["つながるメッシュWi-Fi 開始日"],
          option_tsunagaru_mesh_wifi_cancel: row["つながるメッシュWi-Fi 開始日　キャンセル"],
          option_tsunagaru_mesh_wifi_flag: row["つながるメッシュWi-Fi短期解約"],
          isp_num: row["ISP番号"]
        )
        if nuro.has_changes_to_save? 
          nuro.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        nuro = new(
          controll_num: row["管理番号"],
          user_id: u_id,
          last_name_kana: row["カナ(姓)"],
          prefecture: row["都道府県市区町村"],
          date: row["お申込日"],
          status: row["現状ステータス"],
          remarks: row["備考"],
          status_after_call: row["後確ステータス"],
          status_progress: row["進捗ステータス"],
          status_antena: row["アンテナ施工ステータス"],
          start: row["開通日"],
          revoke: row["キャンセル日"],
          cancel: row["解約日"],
          current_month_cancel: row["光回線短期解約"],
          option_tell: row["電話サービス同時申込有無"],
          option_hikari_tv: row["ひかりTVサービス開始日(1契約目)"],
          option_hikari_tv2: row["ひかりTVサービス開始日(2契約目)"],
          option_seiton_and_hozon: row["SEITON&HOZON 開始日"],
          option_seiton_and_hozon_cancel: row["SEITON&HOZON キャンセル"],
          option_seiton_and_hozon_flag: row["SEITON&HOZON短期解約"],
          option_nuro_hikari_safe: row["NURO 光 Safe 開始日"],
          option_nuro_hikari_safe_cancel: row["NURO 光 Safe 開始日　キャンセル"],
          option_nuro_hikari_safe_flag: row["NURO 光 Safe短期解約"],
          option_nuro_sakutto_support: row["NURO さくっとサポート 開始日"],
          option_nuro_sakutto_support_cancel: row["NURO さくっとサポート 開始日　キャンセル"],
          option_nuro_sakutto_support_flag: row["NURO さくっとサポート短期解約"],
          option_tokutoku_super: row["とくとくネットスーパー 開始日"],
          option_tokutoku_super_cacnel: row["とくとくネットスーパー 開始日　キャンセル"],
          option_tokutoku_super_flag: row["とくとくネットスーパー短期解約"],
          option_nuro_smart_life: row["NUROスマートライフ 開始日"],
          option_nuro_smart_life_cancel: row["NUROスマートライフ 開始日　キャンセル"],
          option_nuro_smart_life_flag: row["NUROスマートライフ短期解約"],
          option_tsunagaru_mesh_wifi: row["つながるメッシュWi-Fi 開始日"],
          option_tsunagaru_mesh_wifi_cancel: row["つながるメッシュWi-Fi 開始日　キャンセル"],
          option_tsunagaru_mesh_wifi_flag: row["つながるメッシュWi-Fi短期解約"],
          isp_num: row["ISP番号"]
          )
        nuro.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 

end
