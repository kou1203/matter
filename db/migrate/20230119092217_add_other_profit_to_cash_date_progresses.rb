class AddOtherProfitToCashDateProgresses < ActiveRecord::Migration[6.1]
  def change
    add_column :cash_date_progresses, :other_profit_current, :integer
    add_column :cash_date_progresses, :other_valuation_current, :integer
    add_column :cash_date_progresses, :other_profit_fin, :integer
    add_column :cash_date_progresses, :other_valuation_fin, :integer
  end
end
