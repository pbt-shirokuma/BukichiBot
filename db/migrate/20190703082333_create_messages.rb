class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :message_id
      t.string :message_type
      t.text :request
      t.text :response
      t.text :reply_response
      t.references :user
      t.timestamps
    end
    add_index :messages, [:user_id, :created_at]
  end
end
