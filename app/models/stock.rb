class Stock < ApplicationRecord

  has_one :praness
  has_one :stock_history
  has_one :return_history

  with_options presence: true do 
    validates :status
    validates :stock_num 
    validates :mac_num 
    validates :mail
    with_options uniqueness: true do 
      validates :stock_num 
      validates :mac_num 
    end 
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
