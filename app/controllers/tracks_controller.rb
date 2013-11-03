class TracksController < ApplicationController

  def index
    @tracks = params[:q] ? Track.search_for(params[:q]) : Track.all(:order => "created_at DESC")
  end

  def new
  	@track = Track.new
  end

  def show
  	@track = Track.find(params[:id])
  end

  def create
  	@track = Track.new(track_params)
    @track.update(artist_name: "Unknown Artist", title: "Unknown Title")

  	if @track.save

      client = SoundCloud.new(:client_id => "284a0193e0651ff008b8d9fe6066e137")
      @sc_track = client.get('/resolve', :url => @track[:original_url])

      if @sc_track["stream_url"] == nil
        flash[:notice] = "SoundCloud user disabled streaming for this one"
        Track.delete(@track.id)
        redirect_to tracks_path
      else
        @track.update(artist_name: @sc_track["user"]["username"], title: @sc_track["title"], stream_url: @sc_track["stream_url"] + "?client_id=284a0193e0651ff008b8d9fe6066e137")
        redirect_to tracks_path
      end

  	else
  		render :new
  	end
  end

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
