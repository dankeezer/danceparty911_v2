class Track < ActiveRecord::Base
	attr_accessible :title, :stream_url, :artist_name, :original_url
	belongs_to :user

	def self.search_for(query)
		where("artist_name LIKE :query OR title LIKE :query OR stream_url LIKE :query OR original_url LIKE :query", query: "%#{query}%")
	end

	def skip_validation
		[:original_url] == "up down left right a b start"
  	end

	def self.set_secret_playlist

		@playlist_url = JSON.parse(open("index.json").read)
		@playlist = @playlist_url["tracks"]
		@playlist.reverse!
		@playlist.each do |track|
			Track.create artist_name: track["artistName"], title: track["title"], stream_url: track["path"]
		end
		"success"
  	end

  	def self.get_track(response)
  		if response.purchase_url.nil?
  			{ title: response.title, stream_url: response.stream_url, artist_name: 'soundcloud' }
  		else
  			{ title: response.title, stream_url: response.stream_url, artist_name: response['user']['username'] }
  		end
  	end

  	def self.get_tracks(response)
  		tracks = []
  		soundcloud_playlist_array = response["tracks"]
  		soundcloud_playlist_array.reverse!
  		soundcloud_playlist_array.each do |track|
  			if track.purchase_url.nil?
  				tracks << { title: track.title, stream_url: track.stream_url, artist_name: "soundcloud" }
  			elsif !track.purchase_url.nil?
  				tracks << { title: track.title, stream_url: track.stream_url, artist_name: track["user"]["username"] }	
  			end
  		end
  		tracks
  	end
end
