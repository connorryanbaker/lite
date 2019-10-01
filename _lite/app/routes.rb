require_relative '../config/router.rb'
require_relative './controllers/public_controller'
require_relative './controllers/users_controller'

Router.new.draw do
  get Regexp.new('^\/public/.*$'), PublicController, :serve
  get Regexp.new('^\/users/new$'), UsersController, :new
  get Regexp.new('^\/users$'), UsersController, :index
  post Regexp.new('^\/users$'), UsersController, :create
  delete Regexp.new('^\/users\/\d+$'), UsersController, :delete
end
