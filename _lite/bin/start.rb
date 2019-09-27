require 'rack'
require_relative '../config/router'
require_relative '../config/show_exceptions'
require_relative '../config/static'
require_relative '../config/env_parser'
require_relative '../sandbox/public_controller'
require_relative '../sandbox/users_controller'
require_relative '../sandbox/sessions_controller'

router_path = File.join(Dir.pwd + '/sandbox/routes.rb')
router = eval(File.readlines(router_path)[4..-1].join(''))

app = Proc.new do |env|
  env = EnvParser::check_form_vars(env)
  req = Rack::Request.new(env)
  res = Rack::Response.new
	router.run(req,res)
  res.finish
end

app = Rack::Builder.new do
  # use Static
  use ShowExceptions
  run app
end.to_app

Rack::Server.start({
  app: app,
  Port: 3000
})
