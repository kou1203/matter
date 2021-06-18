class TroubleN < ApplicationRecord
  belongs_to :user

  with_options presence: true do 
    validates :base
    validates :date
    validates :category
    validates :customer_name
    validates :get_status
    validates :contract_type
    validates :user_id 
    validates :content_type  
    validates :customer_caller
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
      "base",
     "date",
     "category",
     "customer_name",
     "get_status",
     "contract_type",
     "user_id",
     "confirmer",
     "content_type",
     "customer_caller",
     "customer_opinion",
     "user_opinion",
     "result"
    ]
  end 
end
