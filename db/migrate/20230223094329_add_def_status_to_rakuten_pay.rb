class AddDefStatusToRakutenPay < ActiveRecord::Migration[6.1]
  def change
    add_column :rakuten_pays, :def_status, :string
    add_column :rakuten_pays, :client_def_date, :date
    add_column :rakuten_pays, :client_def_solution, :date
  end
end
