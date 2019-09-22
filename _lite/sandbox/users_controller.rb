require_relative '../controllers/controller_base'
require_relative '../models/app/user'
class UsersController < ControllerBase
  def index
  end

  def create
    name = req.params['name']
    @user = User.new(name: name)
    debugger
    @user.save
  end
end
