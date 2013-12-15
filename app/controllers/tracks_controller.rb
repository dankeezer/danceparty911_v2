class TracksController < ApplicationController
  respond_to :html, :js, :json
  protect_from_forgery :except => :receive_guest
  helper_method :current_or_guest_user

  layout "navbar", except: [:index, :show]

  def index
    if User.find(current_or_guest_user).tracks.empty?
      flash.now[:info] = "Enter a soundcloud URL. Here's one to get you started!"
    end
    @user = User.find(current_or_guest_user)
    @tracks = User.find(current_or_guest_user).tracks.order("created_at DESC")
    @track = Track.new
    respond_with(@tracks)
  end

  def new
    @track = Track.new
  end

  def show
    @user = User.find_by_username!(params[:id])
    @tracks = User.find(@user).tracks.order("created_at DESC")
    @track = Track.new
    respond_with(@tracks)
  end

  def create
    @tracks = []
    if params[:track][:original_url] == "keezer"
      @secret_code_data = Track.set_secret_playlist
      @secret_code_data.each do |data|
        track = Track.new(title: data[:title], stream_url: data[:stream_url], artist_name: data[:artist_name])
        track.user_id = current_or_guest_user.id
        @tracks << track
        track.save
      end
      flash[:success] = "You found a secret"
      respond_with(@tracks.reverse!)

    elsif params[:track][:original_url] =~ /\Ahttps?:\/\/soundcloud/
      errors = []
      @tracks = []
      response = SOUNDCLOUD_CLIENT.get('/resolve', :url => params[:track][:original_url])
      
      @soundcloud_data = Track.get_tracks(response)
      
      @soundcloud_data[:info].each do |data|
        track = Track.new(title: data[:title], stream_url: data[:stream_url], artist_name: data[:artist_name], original_url: params[:track][:original_url])
        track.user_id = current_or_guest_user.id
        track.save
        @tracks << track
      end

      @soundcloud_data[:alerts].first[:success].nil? ? nil : flash[:success] = @soundcloud_data[:alerts].first[:success]
      @soundcloud_data[:alerts].last[:error].nil? ? nil : flash[:error] = @soundcloud_data[:alerts].last[:error]
      respond_with(@tracks.reverse!)
      
    else
      flash[:error] = "Not a valid SoundCloud URL"
      respond_with(@tracks)
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

  def remove_all
    @tracks = User.find(current_or_guest_user).tracks
    @count = @tracks.count
    if @tracks.empty?
      flash[:error] = "Nothing to remove!"
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
    @tracks = User.find(params[:id]).tracks.order("created_at DESC")
    @track = Track.new
    respond_with(@tracks)
  end

  def single_list
    # User.find(current_or_guest_user).update_attributes(:dj_this_list => false)
    @tracks = User.find(params[:id]).tracks.order("created_at DESC")
    @track = Track.new
    respond_with(@tracks)
  end

  private


  def track_params
    params.require('track').permit(:artist_name, :title, :stream_url, :original_url)
  end

end
