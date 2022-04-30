class AddProfitToResults < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :profit, :integer
    add_column :results, :product, :string
  end
end
