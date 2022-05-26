class AddColumnResultCashes < ActiveRecord::Migration[6.1]
  def change
    add_column :result_cashes, :dmer, :integer
    add_column :result_cashes, :aupay, :integer
    add_column :result_cashes, :paypay, :integer
    add_column :result_cashes, :rakuten_pay, :integer
  end
end
