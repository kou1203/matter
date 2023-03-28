class AddRecordNumToAupays < ActiveRecord::Migration[6.1]
  def change
    add_column :aupays, :record_num, :string
  end
end
