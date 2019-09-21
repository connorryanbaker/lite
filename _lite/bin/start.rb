require 'rack'
require_relative '../config/router'
require_relative '../sandbox/users_controller'

router_path = File.join(Dir.pwd + '/sandbox/routes.rb')
router = eval(File.readlines(router_path)[2..-1].join(''))

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req,res)
  res.finish
end

Rack::Server.start({
  app: app,
  Port: 3000
})
