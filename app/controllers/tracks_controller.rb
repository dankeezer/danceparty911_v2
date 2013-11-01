class TracksController < ApplicationController
  def index
    @tracks = Track.search_for(params[:q])
  end

  def new
  	@track = Track.new
  end

  def show
  	@track = Track.find(params[:id])
  end

  def create
  	@track = Track.new(track_params)
  	if @track.save
  		redirect_to @track
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

  #soundcloud tracks
  sc_track = client.get('/resolve', :url => "https://soundcloud.com/youngdaniel/n-y-state-of-diamonds-young")


 private

 def track_params
 	params.require('track').permit(:artist_name, :title, :stream_url)
 end

end
