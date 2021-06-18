class SummitCustomerProp < ApplicationRecord
  has_many :summits
  belongs_to :store_prop 
  
  with_options presence: true do 
    validates :customer_num 
    validates :client 
    validates :store_prop_id 
    validates :claim_house 
    validates :claim_address 
    validates :contract_name 
  end 
  
  validates :customer_num, uniqueness: true 

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
      "store_prop_id",
      "claim_house",
      "claim_address",
      "contract_name",
      "before_electric"
    ]
  end

end
