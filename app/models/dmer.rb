class Dmer < ApplicationRecord
  belongs_to :user 
  belongs_to :store_prop

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      store = find_by(id: row["id"]) || new 

      store.attributes = row.to_hash.slice(*updatable_attributes)
      store.save
    end
  end

  def self.updatable_attributes
    ["store_prop_id", "user_id","status","get_date", "mail","description", "payment", "settlement_payment","picture_payment"]
  end

end
