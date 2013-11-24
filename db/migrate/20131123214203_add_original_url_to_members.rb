class AddOriginalUrlToMembers < ActiveRecord::Migration
  def change
    add_column :members, :original_url, :string
  end
end
