class LoginController < ApplicationController
	helper_method :remove_guest_users
	protect_from_forgery :except => :receive_guest
	layout false

  def index
    	@users = params[:q] ? User.search_for(params[:q]) : User.all
  end

  def remove_all_guest
    User.all.each do |user|
    	if user.email =~ /\Aguest_(.*)/
    	   user.tracks.delete_all
    	   user.delete
    	end
    Track.all.each do |track|
    	if track.user_id.nil?
    		track.delete
    	end
    end
  end

    redirect_to login_path
  end
end
