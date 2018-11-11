class DjController < ApplicationController
	respond_to :html, :js, :json
	protect_from_forgery :except => :receive_guest
	helper_method :current_or_guest_user
	layout "navbar"

	def index
	  @user = User.find(current_or_guest_user)
	end

	def show
		@user = User.where(username: params[:username]).first
		if @user.nil?
			redirect_to "/"
		else
	  	@tracks = @user.tracks.order("created_at DESC").all
      @track = Track.new
	  	respond_with(@user)
	  end
	end

  def user
    #@tracks = User.find(params[:user]).tracks
    @tracks = Track.where(user_id: params[:username])
  end
end