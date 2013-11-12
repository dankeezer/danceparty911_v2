class WelcomeController < ApplicationController

	protect_from_forgery :except => :receive_guest
	helper_method :current_or_guest_user
	
	def index
		@tracks = params[:q] ? Track.search_for(params[:q]) : Track.all
		@users = params[:q] ? User.search_for(params[:q]) : User.all
	end
end