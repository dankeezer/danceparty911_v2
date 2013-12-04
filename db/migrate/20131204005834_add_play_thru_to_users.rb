class AddPlayThruToUsers < ActiveRecord::Migration
  def change
    add_column :users, :play_thru, :boolean
  end
end
