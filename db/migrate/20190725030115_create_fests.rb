class CreateFests < ActiveRecord::Migration[5.2]
  def change
    create_table :fests do |t|
      t.string :fest_name , null: false
      t.integer :fest_status , null: false, default: 0
      t.string :fest_image
      t.string :selection_a , null: false
      t.string :selection_b , null: false
      t.string :fest_result
      t.text :description
      t.datetime :term_from
      t.datetime :term_to
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :fests , [:created_at]
  end
end
