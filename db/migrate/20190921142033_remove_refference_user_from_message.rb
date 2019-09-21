class RemoveRefferenceUserFromMessage < ActiveRecord::Migration[5.2]
  def change
    remove_reference :messages, :user, index: true
  end
end
