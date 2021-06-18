class Panda < ApplicationRecord

  with_options presence: true do 
    validates :user_id
    validates :store_prop_id
    validates :get_date 
  end 
  with_options uniqueness: true do 
    validates :grid_id
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
    [
      "grid_id",
      "food_category",
      "client",
      "user_id",
      "store_prop_id",
      "get_date",
      "ghost_flag",
      "docu_sign_send",
      "docu_sign_done",
      "quality_check",
      "delivery_arrangements",
      "traning",
      "result_point",
      "payment",
      "remarks",
      "status",
      "confirm_ball",
      "confirm_date",
      "confirmer",
      "deficiency",
      "deficiency_result",
      "solution_date",
      "valuation_profit",
      "actual_profit"
    ]
  end
  
end
