class RemoveBpmFromTracks < ActiveRecord::Migration
  def change
    remove_column :tracks, :bpm, :integer
  end
end
