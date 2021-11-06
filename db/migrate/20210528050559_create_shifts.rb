class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.references :user                  , foreign_key: true 
      t.string :shift                     , null: false 
      t.datetime :start_time              , null: false 

      t.timestamps
    end
  end
end
