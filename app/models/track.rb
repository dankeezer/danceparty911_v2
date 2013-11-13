class Track < ActiveRecord::Base
	attr_accessible :title, :stream_url, :artist_name, :original_url
	belongs_to :user

	def self.search_for(query)
		where("artist_name LIKE :query OR title LIKE :query OR stream_url LIKE :query OR original_url LIKE :query", query: "%#{query}%")
	end

      # if @soundcloud_data.count > 1
      #   flash[:notice] = "Successfully added #{@soundcloud_data.count} tracks."
      # else
      #   flash[:notice] = "Successfully added #{@soundcloud_data[:title]}"
      # end

      # errored_track_count = response["tracks"].count - @soundcloud_data.count
      # if errored_track_count > 1
      #   flash[:error] = "SoundCloud user disabled streaming for #{errored_track_count} tracks."
      # elsif errored_track_count == 1
      #   flash[:error] = "SoundCloud user disabled streaming for 1 track."
      # end

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
    track = { alerts: [], info: [] }
    if response.streamable?
      if response.purchase_url.nil?
        track[:info] << { title: response.title, stream_url: response.stream_url, artist_name: 'soundcloud' }
      else
        track[:info] << { title: response.title, stream_url: response.stream_url, artist_name: response['user']['username'] }
      end
      track[:alerts] << { success: "Successfully added #{response.title}." }
      track
    else
      track[:alerts] << { error: "SoundCloud user disabled streaming for this track."}
    end
	end

	def self.get_tracks(response)
    errors = []
    successes = []
		tracks = { alerts: [], info: [] }
    if response.kind == 'track'
        soundcloud_playlist_array = [ response ]
    elsif response.kind == 'playlist'
        soundcloud_playlist_array = response["tracks"]
        soundcloud_playlist_array.reverse!
    end
		soundcloud_playlist_array.each do |track|
      if track.streamable?
  			if track.purchase_url.nil?
  				tracks[:info] << { title: track.title, stream_url: track.stream_url, artist_name: "soundcloud" }
  			elsif !track.purchase_url.nil?
  				tracks[:info] << { title: track.title, stream_url: track.stream_url, artist_name: track["user"]["username"] }	
  			end
        successes << { title: track.title }
      else
        errors << { title: track.title }
      end
    end

    if successes.count > 1
      tracks[:alerts] << { success: "Successfully added #{successes.count} tracks." }
    elsif successes.count == 1
       tracks[:alerts] << { success: "Successfully added 1 track." }
    end

    if errors.count > 1
      tracks[:alerts] << { error: "SoundCloud user disabled streaming for #{errors.count} tracks." }
    elsif errors.count == 1
      tracks[:alerts] << { error: "SoundCloud user disabled streaming for 1 track." }
    elsif errors.count == 0
      nil
    end
		tracks
	end
end
