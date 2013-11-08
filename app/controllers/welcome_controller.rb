class WelcomeController < ApplicationController
	def index
		@tracks = params[:q] ? Track.search_for(params[:q]) : Track.all
		@users = params[:q] ? User.search_for(params[:q]) : User.all
	end
end