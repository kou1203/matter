class StoreProp < ApplicationRecord
  with_options presence: true do 
    validates :race
    validates :name
    validates :suitable_time
    validates :industry
    validates :person_main
    validates :phone_number_1
    validates :prefectures
    validates :city
    validates :municipalities
    validates :address

  end 


  has_one :dmer

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      store = find_by(id: row["id"]) || new 

      store.attributes = row.to_hash.slice(*updatable_attributes)
      store.save
    end
  end

  def self.updatable_attributes
    ["race", "name", "suitable_time","description","industry", "phone_number_1","phone_number_2", "person_main", "person_sub", "prefectures","city", "municipalities", "address", "building_name"]
  end
end
