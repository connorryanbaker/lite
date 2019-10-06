# lite
lite is an MVC web framework and orm written in ruby. 
This framework began as an attempt to combine the end result of two projects we teach at App Academy, Rails Lite and Active Record Lite.
Combining the two into a cohesive framework has been an edifying process, resulting in a full featured product with which one can interact much in the same way as with Ruby on Rails.
A very simple todo app was created using lite and hosted on EC2, check it out at www.tododododo.best or https://github.com/connorryanbaker/lite_framework_sample_app

Features include:

1. Routing
  - Routes are created by instantiating a `Router`, calling the method `#draw` and passing it a block made up of individual routes to be created
  - Each of these individual routes takes a HTTP verb (get, post, put or delete), a path in the form of a Regex, the name of the controller that will be instantiated to handle this request and the method to be invoked on that controller
```ruby
Router.new.draw do
  get Regexp.new('^\/todos/(?<id>\d+)/edit'), TodosController, :edit
  put Regexp.new('^\/todos/(?<id>\d+)$'), TodosController, :update
  delete Regexp.new('^\/todos/(?<id>\d+)$'), TodosController, :destroy
end
```

```ruby
class Router
 # ...
  def add_route(pattern, method, controller_class, action_name)
    routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
    self
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) {|p, cc, ac| add_route(p, http_method, cc, ac)}
  end
  # ...
end
```

2. Controller Base (inspired by ActionController)
  - Controllers in lite that inherit from ControllerBase are ininitialized with a Rack::Request, Rack::Response and params hash. Inheritting from ControllerBase allows one to write controllers in the spirit of controllers in Rails.
```ruby
class TodosController < ControllerBase
  def create
    @todo = Todo.new(title: params['title'],
                       description: params['description'],
                       user_id: params['user_id'])
    if @todo.save
      redirect_to("/users/#{@todo.user_id}")
    else
      render('show', 'users_controller')
    end
  end

  def edit
    @todo = Todo.where(id: params['id'])
    render('edit')
  end
  # ...
end
```
3. Model Base (inspired by ActiveRecord::Base)
4. Database Migrations
5. Templating using ERB
6. Session based Authentication
7. Flash notifications
8. Serving public assets

Developing lite continues to be an enjoyable and instructive process. Upcoming features include...
1. More robust validations for ModelBase
2. Regex-free routes
3. PostgreSQL support
