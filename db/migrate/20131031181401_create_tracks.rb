class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :artist_name
      t.string :title
      t.string :stream_url

      t.timestamps
    end
  end
end
