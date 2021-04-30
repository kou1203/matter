class StoreProp < ApplicationRecord

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      store = find_by(id: row["id"]) || new 

      store.attributes = row.to_hash.slice(*updatable_attributes)
      store.save
    end
  end

  def self.updatable_attributes
    ["race", "name", "suitable_time","description","industry", "phone_number_1","phone_number_2", "person", "prefectures","city", "municipalities", "address", "building_name"]
  end
end
