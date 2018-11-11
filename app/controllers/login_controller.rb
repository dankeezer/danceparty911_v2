class LoginController < ApplicationController
  helper_method :remove_guest_users
  protect_from_forgery except: :receive_guest
  layout false

  def index
    @users = params[:q] ? User.search_for(params[:q]) : User.all
  end

  def remove_all_guest
    User.all.each do |user|
      regex = /\Aguest_(.*)/
      if regex.match?(user.email)
        user.tracks.delete_all
        user.delete
      end
      Track.all.each { |track| track.delete if track.user_id.nil? }
    end

    redirect_to login_path
  end
end
