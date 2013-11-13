class LoginController < ApplicationController

	protect_from_forgery :except => :receive_guest

	layout "navbar"

def index
  	@users = params[:q] ? User.search_for(params[:q]) : User.all
end

end
