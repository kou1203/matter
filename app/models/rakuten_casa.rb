class RakutenCasa < ApplicationRecord
  belongs_to :user
  belongs_to :putter, class_name: "User", optional: true
  belongs_to :store_prop

  with_options presence: true do 
    validates :client 
    validates :user_id 
    validates :store_prop_id 
    validates :date
    validates :status
    validates :net_confirm_method
    validates :net_name
    validates :hikari_collabo
    validates :net_plan
    validates :customer_num
    validates :net_contracter
    validates :net_contracter_kana
    validates :net_phone_number
    validates :error_status
    validates :status_put
    validates :profit_new
    validates :profit_put  
    validates :valuation_new  
    validates :valuation_put  
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      casa = find_by(id: row["id"]) || new 
      casa.attributes = row.to_hash.slice(*updatable_attributes)
      casa.save      
    end
  end

  def self.updatable_attributes 
    [
      "store_prop_id",
      "user_id",
      "date",
      "contract_type",
      "contracter",
      "line_type",
      "confirm_method",
      "hikari_collabo",
      "line_service",
      "customer_num",
      "femto_id",
      "status",
      "error_status",
      "error_confirmer",
      "remarks",
      "payment",
      "get_profit",
      "put_profit"
    ]
  end
end
