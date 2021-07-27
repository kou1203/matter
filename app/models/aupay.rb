class Aupay < ApplicationRecord
  belongs_to :user 
  belongs_to :settlementer ,class_name: "User", optional: true
  belongs_to :store_prop 

  with_options presence: true do 
    validates :customer_num
    validates :client
    validates :user_id
    validates :store_prop_id
    validates :date 
    validates :status
    validates :status_settlement
    validates :profit_new
    validates :profit_settlement
    validates :valuation_new
    validates :valuation_settlement
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
      "settlement",
      "settlement_deadline",
      "description",
      "get_profit",
      "settlement_profit"
    ]
  end


end
