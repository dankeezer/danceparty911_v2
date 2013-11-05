class Track < ActiveRecord::Base
	attr_accessible :title, :stream_url, :artist_name, :original_url

	belongs_to :user
	
	def self.search_for(query)
		where("artist_name LIKE :query OR title LIKE :query OR stream_url LIKE :query OR original_url LIKE :query", query: "%#{query}%")
	end

	#validates text is includes "soundcloud" or "easter egg" will remove first if/else



end
