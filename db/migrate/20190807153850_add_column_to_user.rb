class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_token, :string
    change_column :users, :line_id, :string, null: true
  end
end
