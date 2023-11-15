class CreateDmerSenbaiDateProgresses < ActiveRecord::Migration[6.1]
  def change
    create_table :dmer_senbai_date_progresses do |t|
      t.references :user                   ,foreign_key: true
      t.string :base                       ,null: false 
      t.date :date                         ,nill: false
      t.integer :shift_schedule               ,null: false 
      t.integer :shift_schedule_slmt          ,null: false 
      t.integer :shift_digestion              ,null: false 
      t.integer :shift_digestion_slmt         ,null: false 
      t.integer :get_len                   ,null: false 
      t.integer :def_len                   ,null: false 
      t.integer :fin_len                   ,null: false 
      t.integer :valuation_current         ,null: false 
      t.integer :valuation_current1        ,null: false 
      t.integer :valuation_current2        ,null: false 
      t.integer :valuation_current3        ,null: false 
      t.integer :valuation_fin             ,null: false 
      t.integer :valuation_fin1            ,null: false 
      t.integer :valuation_fin2            ,null: false 
      t.integer :valuation_fin3            ,null: false 
      t.integer :profit_current            ,null: false 
      t.integer :profit_fin                ,null: false 
      t.date :create_date                  ,null: false 
    end
  end
end
