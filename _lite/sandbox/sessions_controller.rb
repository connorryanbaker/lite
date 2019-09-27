require_relative '../controllers/controller_base'
require_relative '../models/app/user'

class SessionsController < ControllerBase
	def create
    user = User.authenticate(params)
    if user
			session[:key] = user.reset_session_token!
    end 
    redirect_to('/users')
	end
  
  def destroy
    if current_user
			current_user.reset_session_token!
    end 
    session[:key] = nil
    redirect_to('/users')
  end
  
  def new
    render('new')
  end 
  
  def current_user
    User.where(session_token: session[:key])[0]
  end 
end
