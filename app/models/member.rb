class Member < ActiveRecord::Base
  attr_accessible :name

	def self.set_secret_playlist
    tracks = []
    @playlist_url = JSON.parse(open("index.json").read)
    @playlist = @playlist_url["tracks"]
    @playlist.reverse!
    @playlist.each do |track|
      tracks << { artist_name: track["artistName"], title: track["title"], stream_url: track["path"] }
    end
    tracks
  end

end
