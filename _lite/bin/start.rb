require 'rack'
require_relative '../config/router'
require_relative '../config/show_exceptions'
require_relative '../sandbox/users_controller'

router_path = File.join(Dir.pwd + '/sandbox/routes.rb')
router = eval(File.readlines(router_path)[2..-1].join(''))

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req,res)
  res.finish
end

app = Rack::Builder.new do
  use ShowExceptions
  run app
end.to_app

Rack::Server.start({
  app: app,
  Port: 3000
})
