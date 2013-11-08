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
  		# shovel overwrites tracks every time it iterates. also, tracks is not returned at the end of method.
  		# no stream_url validation goes here or as a for real validation?
  		end
  		tracks
  	end



    #     if @soundcloud_url.kind == "playlist"
    #       tracks = Track.get_playlist(@soundcloud_url) # in model this will be self.get_playlist
    #       persisted_tracks = tracks.inject(Array.new) do |tracks, track|
    #         tracks << Track.create(title: @soundcloud_url["title"], stream_url: @soundcloud_url["stream_url"] + "?client_id=284a0193e0651ff008b8d9fe6066e137", user_id: current_user.id)
    #       end
    #       if persisted_tracks.each { |track| track.errors.any? redirect_to :new }

	#   soundcloud_url.kind == "track"

		

        # track = Track.create title: soundcloud_url["title"], stream_url: soundcloud_url["stream_url"] + "?client_id=284a0193e0651ff008b8d9fe6066e137"
	       #  if soundcloud_url["purchase_url"] != nil
	       #      track.update(artist_name: soundcloud_url["user"]["username"]) 
	       #  else
	       #      track.update(artist_name: "SoundCloud")
	       #  end
	       #  "success"
	    
    #       if @track.save
    #          redirect_to tracks_path
    #       else
    #         render :new
    #       end
    #     else
    #       flash[:notice] = "Not a SoundCloud playlist or track"
    #       redirect_to tracks_path
    #     end
	# end


  # 	def self.get_playlist
		# @soundcloud_playlist = @soundcloud_url["tracks"]
		# @soundcloud_playlist.reverse!
		# @soundcloud_playlist.each do |t|
		# 	@pl_track = Track.create title: t.title, stream_url: t.stream_url + "?client_id=284a0193e0651ff008b8d9fe6066e137" 
		# 	@pl_track
		# 	if t.purchase_url != nil
		# 		@pl_track.update(artist_name: t["user"]["username"]) 
		# 	else
		# 		@pl_track.update(artist_name: "SoundCloud")
		# 	end
		# end

		# if stream_error_count == 1
		# 	flash[:notice] = "SoundCloud user disabled streaming for 1 track."
		# elsif stream_error_count > 1
		# 	flash[:notice] = "SoundCloud user disabled streaming for #{n} tracks."
		# elsif stream_error_count == 0
		# 	nil
		# end
  #   end

	#validates text is includes "soundcloud" or "easter egg" will remove first if/else



end
