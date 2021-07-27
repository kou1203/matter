class RakutenCasa < ApplicationRecord
  belongs_to :user
  belongs_to :store_prop

  with_options presence: true do 
    validates :user 
    validates :store_prop_id 
    validates :date
    validates :contract_type
    validates :contracter
    validates :line_type
    validates :confirm_method
    validates :line_service
    validates :get_profit
    validates :put_profit  
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
