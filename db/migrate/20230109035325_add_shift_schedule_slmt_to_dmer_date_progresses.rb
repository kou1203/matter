class AddShiftScheduleSlmtToDmerDateProgresses < ActiveRecord::Migration[6.1]
  def change
    add_column :dmer_date_progresses, :shift_schedule_slmt, :integer
    add_column :dmer_date_progresses, :shift_digestion_slmt, :integer
  end
end
