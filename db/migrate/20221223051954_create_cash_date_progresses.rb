class CreateCashDateProgresses < ActiveRecord::Migration[6.1]
  def change
    create_table :cash_date_progresses do |t|
      t.references :user                    ,foreign_key: true
      t.string :base
      t.date :date                           , null: false
      # 現状売上
      t.integer :shift_schedule
      t.integer :shift_digestion
      t.integer :dmer_profit_current
      t.integer :aupay_profit_current
      t.integer :paypay_profit_current
      t.integer :rakuten_pay_profit_current
      t.integer :airpay_profit_current
      t.integer :demaekan_profit_current
      t.integer :austicker_profit_current
      t.integer :dmersticker_profit_current
      t.integer :profit_current

      t.integer :dmer_valuation_current
      t.integer :aupay_valuation_current
      t.integer :paypay_valuation_current
      t.integer :rakuten_pay_valuation_current
      t.integer :airpay_valuation_current
      t.integer :demaekan_valuation_current
      t.integer :austicker_valuation_current
      t.integer :dmersticker_valuation_current
      t.integer :valuation_current
      # 終着
      t.integer :dmer_profit_fin
      t.integer :aupay_profit_fin
      t.integer :paypay_profit_fin
      t.integer :rakuten_pay_profit_fin
      t.integer :airpay_profit_fin
      t.integer :demaekan_profit_fin
      t.integer :austicker_profit_fin
      t.integer :dmersticker_profit_fin
      t.integer :profit_fin

      t.integer :dmer_valuation_fin
      t.integer :aupay_valuation_fin
      t.integer :paypay_valuation_fin
      t.integer :rakuten_pay_valuation_fin
      t.integer :airpay_valuation_fin
      t.integer :demaekan_valuation_fin
      t.integer :austicker_valuation_fin
      t.integer :dmersticker_valuation_fin
      t.integer :valuation_fin

      t.date :create_date                   ,  null: false
    end
  end
end
