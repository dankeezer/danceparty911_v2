class MembersController < ApplicationController
	respond_to :html, :js, :json
	layout "navbar", except: [:index]


	def index
    	@members = Member.all.order("created_at DESC")
    	@member = Member.new
    	respond_with(@members)
  	end

	def create
	  @members = []
	  if params[:member][:name] == "zap"
	  	@secret_code_data = Member.set_secret_playlist
	  	@secret_code_data.each do |data|
        	@member = Member.new(name: data[:title])
        	@member.save
        	@members << @member
        end
        respond_with(@members.reverse!)

	  else
		  flash[:error] = "Error"
	  end
	end

	private

	def track_params
		params.require('track').permit(:name)
	end
end
