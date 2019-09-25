require_relative '../controllers/controller_base'
require_relative '../models/app/user'
class UsersController < ControllerBase
  def index
    @users = User.all
    debugger
    render('index')
  end

  def create
    name = req.params['username']
    @user = User.new(username: name)
    @user.save
    redirect_to('localhost:3000/users')
  end
end
