class CreateDisplayPeriods < ActiveRecord::Migration[6.1]
  def change
    create_table :display_periods do |t|
      t.date :start_period_01       
      t.date :end_period_01         
      t.date :start_period_02       
      t.date :end_period_02         
      t.date :start_period_03       
      t.date :end_period_03         
      t.date :start_period_04       
      t.date :end_period_04         
      t.date :start_period_05       
      t.date :end_period_05         
    end
  end
end
