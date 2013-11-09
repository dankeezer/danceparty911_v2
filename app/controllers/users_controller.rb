class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@users = params[:q] ? User.search_for(params[:q]) : User.all
  end

  def new
  	super
  end

  def update
  	super
  end
  
end