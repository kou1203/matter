class StoreProp < ApplicationRecord
  with_options presence: true do 
    validates :race
    validates :name
    validates :suitable_time
    validates :industry
    validates :person_main
    validates :person_main_kana
    validates :phone_number_1
    validates :prefecture
    validates :city
    validates :municipalities
    validates :address
    validates :mail_1
    validates :holiday

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
      "industry",
      "description",
      "phone_number_1",
      "phone_number_2",
      "person_main",
      "person_main_kana",
      "birthday",
      "person_sub",
      "person_sub_kana",
      "mail_1",
      "mail_2",
      "prefecture",
      "city",
      "municipalities",
      "address",
      "building_name",
      "suitable_time",
      "holiday"
    ]
  end
end
