class AddControllNumToDmers < ActiveRecord::Migration[6.1]
  def change
    add_column :dmers, :controll_num, :string
    add_column :dmers, :def_status, :string
    add_column :dmers, :picture_update, :date
  end
end
