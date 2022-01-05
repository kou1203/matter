class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.datetime :start_time             
      t.string :shift                    
      t.references :user                  , foreign_key: true 
    end
  end
end
