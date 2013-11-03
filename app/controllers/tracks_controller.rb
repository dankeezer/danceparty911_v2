class TracksController < ApplicationController

  def index
    @tracks = params[:q] ? Track.search_for(params[:q]) : Track.all
    #get_from_soundcloud
  end

  def new
  	@track = Track.new
  end

  def show
  	@track = Track.find(params[:id])
  end

  def save_soundcloud_track track
    Track.create title: track[:title], stream_url: track[:stream_url]
  end

  def create
  	@track = Track.new(track_params)
  	if @track.save
  		
      client = SoundCloud.new(:client_id => "284a0193e0651ff008b8d9fe6066e137")
      @sc_track = client.get('/resolve', :url => @track[:original_url])
      t = {title: @sc_track["title"], stream_url: @sc_track["stream_url"] + "?client_id=284a0193e0651ff008b8d9fe6066e137"}
      save_soundcloud_track(t)

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

  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    redirect_to tracks_path
  end




  # def get_from_soundcloud
  #   def find_missing_stream
  #     Track.last[:original_url]
  #   end
  #   client = SoundCloud.new(:client_id => "284a0193e0651ff008b8d9fe6066e137")
  #   @sc_track = client.get('/resolve', :url => find_missing_stream)
  #   t = {title: @sc_track["title"], stream_url: @sc_track["stream_url"]}
  #   save_soundcloud_track(t)
  # end



  # def save_soundcloud_track track
  #     Track.create title: track[:title], stream_url: track[:stream_url]
  # end

  private

  def track_params
 	  params.require('track').permit(:artist_name, :title, :stream_url, :original_url)
  end

end
