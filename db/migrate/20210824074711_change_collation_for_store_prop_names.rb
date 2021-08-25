class ChangeCollationForStorePropNames < ActiveRecord::Migration[6.0]
  def up
    execute("ALTER TABLE store_props MODIFY name varchar(255) BINARY")
  end
end
