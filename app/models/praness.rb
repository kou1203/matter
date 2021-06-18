class Praness < ApplicationRecord

  with_options presence: true do 
    validates :get_date
    validates :user_id
    validates :stock_id
    validates :ssid_1
    validates :ssid_2
    validates :pass_1
    validates :pass_2
    validates :claim
    validates :start
    validates :deadline
    validates :payment
    validates :customer_num, length: { in: 20..20 }
    with_options uniqueness: true do 
      validates :stock_id
    end 
  end 



  belongs_to :user 
  belongs_to :store_prop
  belongs_to :stock

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
      "stock_id",
      "ssid_change",
      "ssid_1",
      "ssid_2",
      "pass_1",
      "pass_2",
      "cancel",
      "return_remarks",
      "remarks",
      "claim",
      "start",
      "deadline",
      "withdrawal"]
  end

end
