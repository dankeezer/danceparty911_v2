class UsersController < ApplicationController

  protect_from_forgery :except => :receive_guest
  before_filter :authenticate_user!
  helper_method :current_or_guest_user

  def index
  	@users = params[:q] ? User.search_for(params[:q]) : User.all
  end

  def new
  	super
  end

  def update
    binding.pry
  	super
  end
  
end