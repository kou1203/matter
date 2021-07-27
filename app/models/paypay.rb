class Paypay < ApplicationRecord

  with_options presence: true do 
    validates :user_id 
    validates :store_prop_id
    validates :date
    validates :status
    validates :client
    validates :profit
    validates :valuation
  end 

  belongs_to :store_prop
  belongs_to :user

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      store = find_by(id: row["id"]) || new 
      store.attributes = row.to_hash.slice(*updatable_attributes)
      store.save
    end
  end

  def self.updatable_attributes
    ["store_prop_id",
      "user_id",
      "status",
      "get_date",
      "payment",
      "client",
      "get_profit",
      "settlement_profit"
    ]
  end

end
