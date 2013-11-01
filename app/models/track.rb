class Track < ActiveRecord::Base
	attr_accessible :title, :stream_url
	def self.search_for(query)
		where("artist_name LIKE :query OR title LIKE :query OR stream_url LIKE :query", query: "%#{query}%")
	end
end
