class ChangeColumnFest < ActiveRecord::Migration[5.2]
  def up
    change_column :fests, :fest_status, :integer, null: false, default: 0
  end
  
  def down
    change_column :fests, :fest_status ,:string, default: "00"
  end
end
