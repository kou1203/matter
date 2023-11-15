class CreateActivityBases < ActiveRecord::Migration[6.1]
  def change
    create_table :activity_bases do |t|
      t.date :date            ,null: false
      t.references :user      ,foreign_key: true 
      t.string :base          ,null: false
      t.string :position      ,null: false
    end
  end
end
