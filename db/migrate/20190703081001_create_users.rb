class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      
      t.string :name , null: false
      t.string :line_id , null: false
      t.string :status , null: false , default: "00"
      t.string :talk_status , default: "00"
      t.boolean :del_flg , default: false
      t.timestamps
      
    end
    add_index :users , [:created_at]
  end
end
