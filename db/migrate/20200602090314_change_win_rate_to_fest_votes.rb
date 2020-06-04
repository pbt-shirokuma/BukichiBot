class ChangeWinRateToFestVotes < ActiveRecord::Migration[5.2]
  def up
    change_column :fest_votes, :win_rate, :decimal, precision: 5, scale: 2, default: 0.0
  end
  
  def down
    change_column :fest_votes, :win_rate, :decimal, precision: 5, scale: 2
  end
end
