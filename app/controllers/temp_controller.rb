class TempController < ApplicationController


	def index

		session = Hallon::Session.initialize IO.read('./spotify_appkey.key')
		session.login!('dankeezer', 'spotcus3')
		track = Hallon::Track.new("spotify:track:6q8nN6wpsfqpZUMnPJ4c2K").load
		track.load
		player = Hallon::Player.new(Hallon::OpenAL)
		player.play!(track)

	end


end
