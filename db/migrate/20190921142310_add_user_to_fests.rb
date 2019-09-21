class AddUserToFests < ActiveRecord::Migration[5.2]
  def change
    add_reference :fests , :user , index: true
  end
end
