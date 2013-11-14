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
  				tracks[:info] << { title: track.title, stream_url: track.stream_url + "?client_id=" + ENV["SOUNDCLOUD_CLIENT_ID"], artist_name: "soundcloud" }
  			elsif !track.purchase_url.nil?
  				tracks[:info] << { title: track.title, stream_url: track.stream_url + "?client_id=" + ENV["SOUNDCLOUD_CLIENT_ID"], artist_name: track["user"]["username"] }	
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
