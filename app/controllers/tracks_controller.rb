class TracksController < ApplicationController

  def index
    @tracks = params[:q] ? Track.search_for(params[:q]) : Track.all(:order => "created_at DESC")
    @user = current_user.id
  end

  def user
    @tracks = User.find(params[:user]).tracks
  end

  def new
    @track = Track.new
  end

  def show
    @track = Track.find(params[:id])
  end

  def create
    if params[:track][:original_url] == "up down left right a b start"
      @secret_code_data = Track.set_secret_playlist
      @secret_code_data.each do |data|
        track = Track.new(title: data[:title], stream_url: data[:stream_url], artist_name: data[:artist_name], user_id: current_user.id)
        unless track.save
          errors << "Unable to save #{data[:title]}"
        end
      end
      flash[:notice] = "You found a secret."
      redirect_to tracks_path


    else
      response = SOUNDCLOUD_CLIENT.get('/resolve', :url => params[:track][:original_url])
      if response.kind == 'track'
        @soundcloud_data = [ Track.get_track(response) ]
      elsif response.kind == 'playlist'
        @soundcloud_data = Track.get_tracks(response)
      end
      errors = []
      @soundcloud_data.each do |data|
        track = Track.new(title: data[:title], stream_url: data[:stream_url], artist_name: data[:artist_name], user_id: current_user.id)
                raise
        unless track.save
          errors << "Unable to save #{data[:title]}"
        end

      end

      if errors.any?
        flash[:notice] = errors
        redirect_to tracks_path
      else
        flash[:notice] = "Added #{@soundcloud_data.count} tracks."
        redirect_to tracks_path
      end
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
