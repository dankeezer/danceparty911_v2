class LoginController < ApplicationController
def index
  	@users = params[:q] ? User.search_for(params[:q]) : User.all
end

end
