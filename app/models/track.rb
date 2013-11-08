class Track < ActiveRecord::Base
	attr_accessible :title, :stream_url, :artist_name, :original_url
	belongs_to :user

  #validates_format_of :original_url, :with => /\Ahttps?:\/\/soundcloud/, :unless => :skip_validation, :message => "Not a SoundCloud URL"
  #validates_presence_of :stream_url, :message => " SoundCloud user has disabled streaming for this track."

  #validates_format_of :original_url, :with => URI.regexp(['http']), :unless => :skip_validation, :message => " not a valid URL"

  #use new_record? to determine if track has already been saved to database

	def self.search_for(query)
		where("artist_name LIKE :query OR title LIKE :query OR stream_url LIKE :query OR original_url LIKE :query", query: "%#{query}%")
	end

	# def skip_validation
	# 	[:original_url] == "up down left right a b start"
 #  end

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
