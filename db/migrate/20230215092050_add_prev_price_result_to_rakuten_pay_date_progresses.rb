class AddPrevPriceResultToRakutenPayDateProgresses < ActiveRecord::Migration[6.1]
  def change
    add_column :rakuten_pay_date_progresses, :prev_price_result, :integer
    add_column :rakuten_pay_date_progresses, :prev_price_result_fin, :integer
  end
end
