class Aupay < ApplicationRecord
  belongs_to :user 
  belongs_to :store_prop 

  with_options presence: true do 
    validates :user_id
    validates :store_prop_id
    validates :get_date 
    validates :status
    validates :client
    validates :customer_num
    with_options uniqueness: true do 
      validates :customer_num
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
    ["store_prop_id", "user_id","status","get_date", "mail","description", "payment", "settlement", "client"]
  end


end
