class AddDjThisListToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dj_this_list, :boolean
  end
end
