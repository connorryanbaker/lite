require_relative '../../controllers/controller_base'
require_relative '../models/todo'
class TodosController < ControllerBase
  def create
    @todo = Todo.new(title: params['title'],
                       description: params['description'],
                       user_id: params['user_id'])
    if
      @todo.save
      redirect_to("/users/#{@todo.user_id}")
    else
      render('show', 'users_controller')
    end
  end

  def update
  end

  def destroy
    @todo = Todo.where(id: params['id'])[0]
    @todo.remove
    redirect_to("/users/#{@todo.user_id}")
  end
end