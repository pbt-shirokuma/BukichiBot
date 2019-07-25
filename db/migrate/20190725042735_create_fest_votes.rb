class CreateFestVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :fest_votes do |t|
      t.references :fest , null: false
      t.references :user , null: false
      t.string :selection , null: false
      t.integer :game_count , default: 0
      t.integer :win_count , default: 0
      t.decimal :win_rate, precision: 5, scale: 2
      t.timestamps
    end
    add_index :fest_votes , [:fest_id , :user_id, :created_at]
  end
end
