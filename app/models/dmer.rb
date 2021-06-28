class Dmer < ApplicationRecord
  belongs_to :user 
  belongs_to :store_prop

  with_options presence: true do 
    validates :customer_num
    validates :store_prop_id 
    validates :user_id 
    validates :get_date
    validates :status 
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
    [
      "customer_num",
      "client",
      "user_id",
      "store_prop_id",
      "get_date",
      "payment",
      "status",
      "before_status",
      "description",
      "settlement",
      "settlement_deadline",
      "valuation_profit",
      "actual_profit"
    ]
  end

end
