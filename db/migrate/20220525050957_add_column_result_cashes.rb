class AddColumnResultCashes < ActiveRecord::Migration[6.1]
  def change
    add_column :result_cashes, :dmer, :integer
    add_column :result_cashes, :aupay, :integer
    add_column :result_cashes, :paypay, :integer
    add_column :result_cashes, :rakuten_pay, :integer
    add_column :result_cashes, :airpay, :integer
    add_column :result_cashes, :other_product1, :integer
    add_column :result_cashes, :other_product2, :integer
    add_column :result_cashes, :other_product3, :integer
    add_column :result_cashes, :other_product4, :integer
    add_column :result_cashes, :other_product5, :integer
    add_column :result_cashes, :other_product6, :integer
    add_column :result_cashes, :other_product7, :integer
    add_column :result_cashes, :other_product8, :integer
    add_column :result_cashes, :other_product9, :integer
    add_column :result_cashes, :other_product10, :integer
  end
end
