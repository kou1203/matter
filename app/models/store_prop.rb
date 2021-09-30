class StoreProp < ApplicationRecord
  with_options presence: true do 
    validates :race
    validates :name
    validates :industry
    validates :gender_main
    validates :person_main_name
    validates :person_main_kana
    validates :person_main_class
    validates :phone_number_1
    validates :mail_1
    validates :prefecture
    validates :city
    validates :municipalities
    validates :address
  end 

  has_one :dmer
  has_one :praness
  has_one :summit_customer_prop
  has_one :aupay
  has_one :paypay
  has_many :pandas 
  has_one :rakuten_casa 
  has_many :trouble_sses
  has_one :st_insurance
  has_one :rakuten_pay

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      store = StoreProp.find_by(name: row["店舗名"])
      if row["ID"].present?
        store_prop = find_by(id: row["ID"])
        errors << "#{index}行目のIDが不適切です" if store_prop.blank?
      elsif row["区分"].blank?
        errors << "#{index}行目の区分が空欄です。"
      elsif row["店舗名"].blank?
        errors << "#{index}行目の店舗名が空欄です。"
      elsif row["業種"].blank?
        errors << "#{index}行目の業種が空欄です。"
      elsif row["代表者性別"].blank?
        errors << "#{index}行目の代表者性別が空欄です。"
      elsif row["代表者カナ"].blank?
        errors << "#{index}行目の代表者カナが空欄です。"
      elsif row["代表者役職"].blank?
        errors << "#{index}行目の代表者役職が空欄です。"
      elsif row["電話番号1"].blank?
        errors << "#{index}行目の電話番号1が空欄です。"
      elsif row["メールアドレス1"].blank?
        errors << "#{index}行目のメールアドレス1が空欄です。"
      elsif row["都道府県"].blank?
        errors << "#{index}行目の都道府県が空欄です。"
      elsif row["市区"].blank?
        errors << "#{index}行目の市区が空欄です。"
      elsif row["町村"].blank?
        errors << "#{index}行目の町村が空欄です。"
      elsif row["番地"].blank?
        errors << "#{index}行目の番地が空欄です。"
      else  
        store_prop = new(
          id: row["ID"],
          race: row["区分"],
          name: row["店舗名"],
          industry: row["業種"],
          head_store: row["本店名"],
          corporate_name: row["法人名"],
          corporate_address: row["法人住所"],
          corporate_num: row["法人番号"],
          gender_main: row["代表者性別"],
          person_main_name: row["代表者名"],
          person_main_kana: row["代表者カナ"],
          person_main_class: row["代表者役職"],
          person_main_birthday: row["代表者生年月日"],
          gender_sub: row["担当者性別"],
          person_sub_name: row["担当者名"],
          person_sub_kana: row["担当者カナ"],
          person_sub_class: row["担当者役職"],
          person_sub_birthday: row["担当者生年月日"],
          phone_number_1: row["電話番号1"],
          phone_number_2: row["電話番号2"],
          mail_1: row["メールアドレス1"],
          mail_2: row["メールアドレス2"],
          prefecture: row["都道府県"],
          city: row["市区"],
          municipalities: row["町村"],
          address: row["番地"],
          building_name: row["建物名"],
          suitable_time: row["好適時間"],
          holiday: row["定休日"],
          description: row["備考"]
        )
        errors << "#{index}行目のデータを保存できませんでした" if store_prop.invalid?
      end
      
    end
    errors
  end


  def self.import(file)
    new_cnt = 0
    update_cnt = 0
    nochange_cnt = 0
    CSV.foreach(file.path, headers: true) do |row|
      if row["ID"].present?
        store_prop = find(row["ID"])
        store_prop.assign_attributes(
          id: row["ID"],
          race: row["区分"],
          name: row["店舗名"],
          industry: row["業種"],
          head_store: row["本店名"],
          corporate_name: row["法人名"],
          corporate_address: row["法人住所"],
          corporate_num: row["法人番号"],
          gender_main: row["代表者性別"],
          person_main_name: row["代表者名"],
          person_main_kana: row["代表者カナ"],
          person_main_class: row["代表者役職"],
          person_main_birthday: row["代表者生年月日"],
          gender_sub: row["担当者性別"],
          person_sub_name: row["担当者名"],
          person_sub_kana: row["担当者カナ"],
          person_sub_class: row["担当者役職"],
          person_sub_birthday: row["担当者生年月日"],
          phone_number_1: row["電話番号1"],
          phone_number_2: row["電話番号2"],
          mail_1: row["メールアドレス1"],
          mail_2: row["メールアドレス2"],
          prefecture: row["都道府県"],
          city: row["市区"],
          municipalities: row["町村"],
          address: row["番地"],
          building_name: row["建物名"],
          suitable_time: row["好適時間"],
          holiday: row["定休日"],
          description: row["備考"]
           )
        if store_prop.has_changes_to_save?
          store_prop.save!
          update_cnt += 1
        else   
          nochange_cnt += 1
        end 
      elsif StoreProp.find_by(phone_number_1: row["電話番号1"]).present? && StoreProp.find_by(name: row["店舗名"]).present?
        nochange_cnt += 1
      else  
        store_prop = new(
          id: row["ID"],
          race: row["区分"],
          name: row["店舗名"],
          industry: row["業種"],
          head_store: row["本店名"],
          corporate_name: row["法人名"],
          corporate_address: row["法人住所"],
          corporate_num: row["法人番号"],
          gender_main: row["代表者性別"],
          person_main_name: row["代表者名"],
          person_main_kana: row["代表者カナ"],
          person_main_class: row["代表者役職"],
          person_main_birthday: row["代表者生年月日"],
          gender_sub: row["担当者性別"],
          person_sub_name: row["担当者名"],
          person_sub_kana: row["担当者カナ"],
          person_sub_class: row["担当者役職"],
          person_sub_birthday: row["担当者生年月日"],
          phone_number_1: row["電話番号1"],
          phone_number_2: row["電話番号2"],
          mail_1: row["メールアドレス1"],
          mail_2: row["メールアドレス2"],
          prefecture: row["都道府県"],
          city: row["市区"],
          municipalities: row["町村"],
          address: row["番地"],
          building_name: row["建物名"],
          suitable_time: row["好適時間"],
          holiday: row["定休日"],
          description: row["備考"]
        )
        store_prop.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end
end
