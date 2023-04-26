class Stock < ApplicationRecord

  has_one :praness
  with_options presence: true do 
    validates :stock_num 
  end 

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      store = find_by(id: row["id"]) || new 

      store.attributes = row.to_hash.slice(*updatable_attributes)
      store.save
    end
  end


  def self.updatable_attributes
    ["stock_num", "mac_num", "status", "mail","remarks"]
  end
end
