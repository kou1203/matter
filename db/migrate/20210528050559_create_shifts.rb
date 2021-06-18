class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.references :user              ,foreign_key: true 
      t.integer :year                 ,null: false 
      t.integer :month                ,null: false 
      t.integer :house_work           ,null: false
      t.integer :ojt                  ,null: false
      t.integer :cashless_new         ,null: false
      t.integer :n                    ,null: false
      t.integer :cashless_settlement  ,null: false
      t.integer :praness              ,null: false 
      t.integer :summit               ,null: false 
      t.integer :panda                ,null: false
      t.integer :rakuten_casa         ,null: false
      t.integer :goal                 ,null: false
    end
  end
end
