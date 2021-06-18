class Summit < ApplicationRecord
  belongs_to :summit_customer_prop
  belongs_to :user

  with_options presence: true do
    validates :summit_customer_prop_id 
    validates :user_id 
    validates :get_date
    validates :status
    validates :supply_num 
    validates :menu  
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
      "summit_customer_prop_id",
      "user_id",
      "get_date",
      "payment",
      "status",
      "before_status",
      "supply_num",
      "contract_num",
      "menu",
      "plan",
      "contract_type",
      "contract_cap",
      "contract_cap_unit",
      "amount_use",
      "start",
      "claim",
      "claim_expected",
      "remarks"
    ]
  end

end
