require_relative '../controllers/controller_base'
require_relative '../models/app/user'
class UsersController < ControllerBase
  def index
  end

  def create
    name = req.params['username']
    @user = User.new(username: name)
    @user.save
    redirect_to('/users')
  end
end
