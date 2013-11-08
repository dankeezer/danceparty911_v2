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

    if @track[:original_url].include? "soundcloud"

    	if @track.save
        @track.update(artist_name: "Unknown Artist", title: "Unknown Title")
        @sc_url = SOUNDCLOUD_CLIENT.get('/resolve', :url => @track[:original_url])

        if @sc_url.kind == "playlist"
          @sc_playlist = @sc_url["tracks"]
          @sc_playlist.reverse!
          n = 0

          @sc_playlist.each do |t|
            if t.stream_url == nil
              n += 1
            else
              @pl_track = Track.create title: t.title, stream_url: t.stream_url + "?client_id=284a0193e0651ff008b8d9fe6066e137" 
              @pl_track
              if t.purchase_url != nil
                @pl_track.update(artist_name: t["user"]["username"]) 
              else
                @pl_track.update(artist_name: "SoundCloud")
              end
            end

            if n == 1
              flash[:notice] = "SoundCloud user disabled streaming for 1 track."
            elsif n > 1
              flash[:notice] = "SoundCloud user disabled streaming for #{n} tracks."
            elsif n == 0
              nil
            end

          end
          Track.delete(@track.id)
          redirect_to tracks_path


        elsif @sc_url.kind == "track"

          if @sc_url["stream_url"] == nil
            flash[:notice] = "SoundCloud user disabled streaming for this one"
            Track.delete(@track.id)
            redirect_to tracks_path

          else
             if @sc_url["purchase_url"] != nil
                @track.update(artist_name: @sc_url["user"]["username"]) 
            else
                @track.update(artist_name: "SoundCloud")
             end
            @track.update(bpm: @sc_url["bpm"], title: @sc_url["title"], stream_url: @sc_url["stream_url"] + "?client_id=284a0193e0651ff008b8d9fe6066e137")
            redirect_to tracks_path

          end

        else
          flash[:notice] = "Not a playlist or track"
          Track.delete(@track.id)
          redirect_to tracks_path

        end

    	else
    		render :new
    	end

    elsif @track[:original_url].include? "up down left right a b start"
      # @playlist_url = HTTParty.get "http://dankeezer.com/dp911/xyz/index.json"
      @playlist_url = JSON.parse(open("index.json").read)
      @playlist = @playlist_url["tracks"]
      @playlist.reverse!

      @playlist.each do |t|
        Track.create artist_name: t["artistName"], title: t["title"], stream_url: t["path"]
      end

      flash[:notice] = "You found a secret."
      Track.delete(@track.id)
      redirect_to tracks_path

    else
      flash[:notice] = "Not a valid URL"
      Track.delete(@track.id)
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
