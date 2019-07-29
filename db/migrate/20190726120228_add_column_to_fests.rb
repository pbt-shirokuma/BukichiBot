class AddColumnToFests < ActiveRecord::Migration[5.2]
  def change
    add_column :fests, :description, :text
    add_column :fests, :term_from, :datetime
    add_column :fests, :term_to, :datetime
  end
end
