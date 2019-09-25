require_relative '../controllers/controller_base'
require_relative '../models/app/user'
class UsersController < ControllerBase
  def new
    render('new')
  end 

  def index
    @users = User.all
    render('index')
  end

  def create
    name = req.params['username']
    @user = User.new(username: name)
    @user.save
    redirect_to('/users')
  end

  def delete
    @user = User.find(req.path.split('/')[-1].to_i)
    @user.remove
    redirect_to('/users')
  end 
end
