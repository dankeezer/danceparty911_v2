class Track < ActiveRecord::Base
	attr_accessible :title, :stream_url, :artist_name, :original_url

	belongs_to :user
	
	def self.search_for(query)
		where("artist_name LIKE :query OR title LIKE :query OR stream_url LIKE :query OR original_url LIKE :query", query: "%#{query}%")
	end


	def self.set_secret_playlist
		@playlist_url = JSON.parse(open("index.json").read)
		@playlist = @playlist_url["tracks"]
		@playlist.reverse!
		@playlist.each do |t|
			Track.create artist_name: t["artistName"], title: t["title"], stream_url: t["path"]
		end
		"success"
  	end


  	def self.get_playlist
		@soundcloud_playlist = @soundcloud_url["tracks"]
		@soundcloud_playlist.reverse!
		stream_error_count = 0

		@soundcloud_playlist.each do |t|
		if t.stream_url == nil
			stream_error_count += 1
		else
			@pl_track = self.create title: t.title, stream_url: t.stream_url + "?client_id=284a0193e0651ff008b8d9fe6066e137" 
			@pl_track
			if t.purchase_url != nil
				@pl_track.update(artist_name: t["user"]["username"]) 
			else
				@pl_track.update(artist_name: "SoundCloud")
			end
		end

		if stream_error_count == 1
			flash[:notice] = "SoundCloud user disabled streaming for 1 track."
		elsif stream_error_count > 1
			flash[:notice] = "SoundCloud user disabled streaming for #{n} tracks."
		elsif stream_error_count == 0
			nil
		end

		end
      end

	#validates text is includes "soundcloud" or "easter egg" will remove first if/else



end
