class CreateCalcPeriods < ActiveRecord::Migration[6.1]
  def change
    create_table :calc_periods do |t|
      # 商材名、実売か評価売かの区分
      t.string :name                                            ,null: false
      t.string :sales_category                                  ,null: false
      # 獲得期間
      t.integer :start_date_month                               ,null: false
      t.integer :start_date_day                                 ,null: false
      t.integer :end_date_month                                 ,null: false
      t.integer :end_date_day                                   ,null: false
      # 締め日
      t.integer :closing_date_month                             ,null: false
      t.integer :closing_date_day                               ,null: false
      # パーセント
      t.float :this_month_per                                   
      t.float :prev_month_per         
      t.integer :price                          
      t.integer :bonus1_len                          
      t.integer :bonus2_len                          
      t.integer :bonus1_price                          
      t.integer :bonus2_price                          
    end
  end
end
