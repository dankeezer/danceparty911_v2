class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation, :play_thru, :dj_this_list
  has_many :tracks
  after_initialize :init

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  before_destroy :destroy_tracks

  def init
        # self.play_thru ||= true
        # self.dj_this_list ||= false
  end

  #twitter version
  # def self.from_omniauth(auth)
	 #  where(auth.slice(:provider, :uid)).first_or_create do |user|
	 #    user.provider = auth.provider
	 #    user.uid = auth.uid
	 #    user.username = auth.info.nickname
	 #  end
  # end

  def get_username(username)
  	username = username
  	username
  end

  def destroy_tracks
    self.tracks.destroy_all
  end

  #soundcloud version
  def self.from_omniauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_create do |user|
	    user.provider = auth.provider
	    user.uid = auth.uid.to_i
	    user.username = auth.extra.raw_info.username
	  end
  end

	def self.new_with_session(params, session)
	  if session["devise.user_attributes"]
	    new(session["devise.user_attributes"], without_protection: true) do |user|
	      user.attributes = params
	      user.valid?
	    end
	  else
	    super
	  end
	end

	def password_required?
	  super && provider.blank?
	end

	def email_required?
	  super && provider.blank?
    end

	def update_with_password(params, *options)
	  if encrypted_password.blank?
	    update_attributes(params, *options)
	  else
	    super
	  end
	end

end
