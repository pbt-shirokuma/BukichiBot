class CreateFests < ActiveRecord::Migration[5.2]
  def change
    create_table :fests do |t|
      t.string :fest_name , null: false
      t.string :fest_status , default: "00"
      t.string :fest_image
      t.string :selection_a , null: false
      t.string :selection_b , null: false
      t.string :fest_result
      t.timestamps
    end
    add_index :fests , [:created_at]
  end
end
