class TracksController < ApplicationController

  def index
    @tracks = params[:q] ? Track.search_for(params[:q]) : Track.all(:order => "created_at DESC")
    #@tracks = current_user.tracks
  end

  def user
        #@tracks = User.find(params[:user]).tracks
  end

  def new
  	@track = Track.new
  end

  def show
  	@track = Track.find(params[:id])
  end

  def create
    if params[:original_url] == "up down left right a b start"
      Track.set_secret_playlist
      if @track.save
        redirect_to tracks_path
      else
        render :new
      end

    #   if params[:original_url].include? "soundcloud"
    #     params.update(artist_name: "Unknown Artist", title: "Unknown Title")
    #     @soundcloud_url = SOUNDCLOUD_CLIENT.get('/resolve', :url => params[:original_url])

    #     if @soundcloud_url.kind == "playlist"
    #       tracks = Track.get_playlist(@soundcloud_url) # in model this will be self.get_playlist
    #       persisted_tracks = tracks.inject(Array.new) do |tracks, track|
    #         tracks << Track.create(title: @soundcloud_url["title"], stream_url: @soundcloud_url["stream_url"] + "?client_id=284a0193e0651ff008b8d9fe6066e137", user_id: current_user.id)
    #       end
    #       if persisted_tracks.each { |track| track.errors.any? redirect_to :new }

    #     elsif @soundcloud_url.kind == "track"
    #       if @soundcloud_url["stream_url"] == nil
    #         flash[:notice] = "SoundCloud user disabled streaming for this one"
    #         # Track.delete(@track.id)
    #         # redirect_to tracks_path
    #       else
    #         @track = Track.new(title: @soundcloud_url["title"], stream_url: @soundcloud_url["stream_url"] + "?client_id=284a0193e0651ff008b8d9fe6066e137", user_id: current_user.id)
    #         if @soundcloud_url["purchase_url"] != nil
    #             @track.update(artist_name: @soundcloud_url["user"]["username"]) 
    #         else
    #             @track.update(artist_name: "SoundCloud")
    #         end
    #       end
    #       if @track.save
    #          redirect_to tracks_path
    #       else
    #         render :new
    #       end
    #     else
    #       flash[:notice] = "Not a SoundCloud playlist or track"
    #       redirect_to tracks_path
    #     end
    #   end
    # else
    #   flash[:notice] = "Not a valid URL"
    #   redirect_to tracks_path
    end
  end
    ####

  def edit
  	@track = Track.find(params[:id])
  end

  def update
  	@track = Track.find(params[:id])

  	if @track.update_attributes(track_params)
  		redirect_to track_path(@track)
  	else
  		render :edit
  	end
  end

  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    redirect_to tracks_path
  end

  private

  def track_params
 	  params.require('track').permit(:artist_name, :title, :stream_url, :original_url)
  end

end
