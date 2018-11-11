class Track < ActiveRecord::Base
  require 'open-uri'

	attr_accessible :title, :stream_url, :artist_name, :original_url
	belongs_to :user
  after_initialize :init

  #use new_record? to determine if track has already been saved to database

  def init
    @determine_dj ||= false
  end

	def self.search_for(query)
		where("artist_name LIKE :query OR title LIKE :query OR stream_url LIKE :query OR original_url LIKE :query", query: "%#{query}%")
	end

  def self.set_secret_playlist
    playlist_index = JSON.parse(open("#{ENV['ASSET_BASE_PATH']}index.json").read)["tracks"].reverse
    playlist_index.map { |track| {
      artist_name: track["artistName"],
      title: track["title"],
      stream_url: "#{ENV['ASSET_BASE_PATH']}#{track["path"]}" }
    }
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
        if track.title.include? " - "
          title_split = /(?<artist>.+)\-(?<title>.+)/.match(track.title)
          tracks[:info] << { artist_name: title_split[:artist], title: title_split[:title], stream_url: track.stream_url + "?client_id=" + ENV["SOUNDCLOUD_CLIENT_ID"] }
  			elsif !track.purchase_url.nil?
  				tracks[:info] << { artist_name: track["user"]["username"], title: track.title, stream_url: track.stream_url + "?client_id=" + ENV["SOUNDCLOUD_CLIENT_ID"] }	
        else
          tracks[:info] << { artist_name: "soundcloud", title: track.title, stream_url: track.stream_url + "?client_id=" + ENV["SOUNDCLOUD_CLIENT_ID"] }
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
