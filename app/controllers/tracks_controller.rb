class TracksController < ApplicationController

  protect_from_forgery :except => :receive_guest
  helper_method :current_or_guest_user

  layout "navbar", except: [:index]

  def index
    #@users = User.all
      @tracks = User.find(current_or_guest_user).tracks.order("created_at DESC").all

    
    #@tracks = params[:q] ? Track.search_for(params[:q]) : Track.all(:order => "created_at DESC")
    #@track.user_id = current_user.id
    #@tracks = @user.tracks
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
        track = Track.new(title: data[:title], stream_url: data[:stream_url], artist_name: data[:artist_name])
        track.user_id = current_or_guest_user.id        
        unless track.save
          errors << "Unable to save #{data[:title]}"
        end
      end
      flash[:notice] = "You found a secret."
      redirect_to tracks_path

    elsif params[:track][:original_url] =~ /\Ahttps?:\/\/soundcloud/
      response = SOUNDCLOUD_CLIENT.get('/resolve', :url => params[:track][:original_url])
      if response.kind == 'track'
        @soundcloud_data = [ Track.get_track(response) ]
      elsif response.kind == 'playlist'
        @soundcloud_data = Track.get_tracks(response)
      end

      errors = []
      if @soundcloud_data
        @soundcloud_data.each do |data|
        track = Track.new(title: data[:title], stream_url: data[:stream_url], artist_name: data[:artist_name], original_url: params[:track][:original_url])
        track.user_id = current_or_guest_user.id
        track.save
        #unless track.save
        #errors << "Unable to save #{data[:title]}"
        #end
        end
      end

      if @soundcloud_data.count > 1
        flash[:notice] = "Successfully added #{@soundcloud_data.count} tracks."
      else
        flash[:notice] = "Successfully added #{@soundcloud_data[:title]}"
      end

      errored_track_count = response["tracks"].count - @soundcloud_data.count
      if errored_track_count > 1
        flash[:error] = "SoundCloud user disabled streaming for #{errored_track_count} tracks."
      elsif errored_track_count == 1
        flash[:error] = "SoundCloud user disabled streaming for 1 track."
      end

      redirect_to tracks_path
    else
      flash[:error] = "Not a valid SoundCloud URL"
      redirect_to tracks_path
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
