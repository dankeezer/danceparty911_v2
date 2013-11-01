class WelcomeController < ApplicationController
  def index
    @tracks = Track.all.order('updated_at DESC')
    get_from_soundcloud
  end


  def get_from_soundcloud
    client = SoundCloud.new(:client_id => "284a0193e0651ff008b8d9fe6066e137")
    @track = client.get('/resolve', :url => "https://soundcloud.com/youngdaniel/n-y-state-of-diamonds-young")
    t = {title: @track["title"], download_url: @track["download_url"]}
    save_soundcloud_track(t)
  end

  def save_soundcloud_track track
      Track.create title: track[:title], stream_url: track[:download_url]
  end
  	
end