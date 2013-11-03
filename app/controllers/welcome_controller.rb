class WelcomeController < ApplicationController
	def index
		@tracks = params[:q] ? Track.search_for(params[:q]) : Track.all
	end
end