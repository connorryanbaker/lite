require_relative '../config/router.rb'

Router.new.draw do
  get Regexp.new('^\/users$'), UsersController, :index
  post Regexp.new('^\/users$'), UsersController, :create
end
