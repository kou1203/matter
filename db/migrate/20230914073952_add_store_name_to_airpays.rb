class AddStoreNameToAirpays < ActiveRecord::Migration[6.1]
  def change
    add_column :airpays, :store_name, :string
  end
end
