class AddTableToRakutenPays < ActiveRecord::Migration[6.1]
  def change
    add_column :rakuten_pays, :registration, :date
    add_column :rakuten_pays, :payment_schedule, :date
    add_column :rakuten_pays, :payment_deadline, :date
    add_column :rakuten_pays, :payment_flag, :string
  end
end
