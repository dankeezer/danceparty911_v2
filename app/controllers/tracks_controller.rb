class TracksController < ApplicationController
  def index
    @tracks = Track.search_for(params[:q])
  end
end
