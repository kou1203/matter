class StoreProp < ApplicationRecord
  with_options presence: true do 
    validates :race
    validates :name
    validates :industry
    validates :person_main_name
    validates :person_main_kana
    validates :person_main_class
    validates :phone_number_1
    validates :mail_1
    validates :prefecture
    validates :city
    validates :municipalities
    validates :address
    with_options uniqueness: true do 
      validates :name
    end 
  end 

  has_one :dmer
  has_one :praness
  has_one :summit_customer_prop
  has_one :aupay
  has_one :paypay
  has_many :pandas 
  has_one :rakuten_casa 
  has_many :trouble_sses

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      store = find_by(id: row["id"]) || new 

      store.attributes = row.to_hash.slice(*updatable_attributes)
      store.save
    end
  end

  def self.updatable_attributes
    ["race",
      "name",
      "corporate_name",
      "corporate_address",
      "corporate_num",
      "industry",
      "person_main_name",
      "person_main_kana",
      "person_main_class",
      "person_main_birthday",
      "person_sub_name",
      "person_sub_kana",
      "person_sub_class",
      "person_sub_birthday",
      "phone_number_1",
      "phone_number_2",
      "mail_1",
      "mail_2",
      "prefecture",
      "city",
      "municipalities",
      "address",
      "building_name",
      "suitable_time",
      "holiday",
      "head_store",
      "description"
    ]
  end
end
