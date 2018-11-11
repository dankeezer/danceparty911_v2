class TracksController < ApplicationController
  respond_to :html, :js, :json
  protect_from_forgery :except => :receive_guest
  helper_method :current_or_guest_user

  layout "navbar", except: [:index, :show]

  def index
    if User.find(current_or_guest_user).tracks.empty?
      flash.now[:info] = 'Enter a soundcloud URL. Here\'s one to get you started!'.freeze
    end
    @user = User.find(current_or_guest_user)
    @tracks = User.find(current_or_guest_user).tracks.order('created_at DESC')
    @track = Track.new
    respond_with(@tracks)
  end

  def new
    @track = Track.new
  end

  def show
    @user = User.find_by_username!(params[:id])
    @tracks = User.find(@user).tracks.order('created_at DESC')
    @track = Track.new
    respond_with(@tracks)
  end

  def create
    @tracks = []
    regex = /\Ahttps?:\/\/soundcloud/
    url = params[:track][:original_url]

    return secret_playlist if url == ENV['PLAYLIST_PASSWORD']
    return soundcloud_playlist if regex.match?(url)

    flash[:error] = 'Not a valid SoundCloud URL'.freeze
    respond_with(@tracks)
  end

  def soundcloud_playlist
    @tracks = []
    response = SOUNDCLOUD_CLIENT.get('/resolve', url: params[:track][:original_url])

    soundcloud_data = Track.get_tracks(response)
    collect_tracks(soundcloud_data)

    alerts = soundcloud_data[:alerts]
    alerts.first[:success].present? ? flash[:success] = alerts.first[:success] : nil
    alerts.last[:error].present? ? flash[:error] = alerts.last[:error] : nil

    respond_with(@tracks.reverse!)
  end

  def collect_tracks(soundcloud_data)
    soundcloud_data[:info].each do |data|
      track = Track.new(
        title: data[:title],
        stream_url: data[:stream_url],
        artist_name: data[:artist_name],
        original_url: params[:track][:original_url],
        user_id: current_or_guest_user.id
      )
      track.save
      @tracks << track
    end
  end

  def secret_playlist
    secret_code_data = Track.set_secret_playlist
    secret_code_data.each do |data|
      track = Track.new(
        title: data[:title],
        stream_url: data[:stream_url],
        artist_name: data[:artist_name]
      )
      track.user_id = current_or_guest_user.id
      @tracks << track
      track.save
    end
    flash[:success] = 'You found a secret'.freeze

    respond_with(@tracks.reverse!)
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

  def remove_all
    @tracks = User.find(current_or_guest_user).tracks
    @count = @tracks.count
    if @tracks.empty?
      flash[:error] = 'Nothing to remove!'.freeze
    else
      @tracks.delete_all
      flash[:error] = "Removed #{@count} tracks!"
    end
    respond_with(@tracks)
  end

  def play_thru
    User.find(current_or_guest_user).update(play_thru: true)
    respond_with(@tracks)
  end

  def click_pause
    User.find(current_or_guest_user).update(play_thru: false)
    respond_with(@tracks)
  end

  def dj_this_list
    # User.find(current_or_guest_user).update_attributes(:dj_this_list => true)
    @user = User.find(params[:id])
    @tracks = @user.tracks.order('created_at DESC')
    @track = Track.new
    respond_with(@tracks)
  end

  def single_list
    # User.find(current_or_guest_user).update_attributes(:dj_this_list => false)
    @user = User.find(params[:id])
    @tracks = @user.tracks.order('created_at DESC')
    @track = Track.new
    respond_with(@tracks)
  end

  private

  def track_params
    params.require('track').permit(:artist_name, :title, :stream_url, :original_url)
  end
end
