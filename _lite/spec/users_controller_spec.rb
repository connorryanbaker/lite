require 'rack'
require_relative '../sandbox/users_controller'
require_relative '../models/app/user'

describe UsersController do
  describe '#create' do
    let(:req) { Rack::Request.new({'rack.input' => ''}) }
    let(:res) { Rack::Response.new }
    after :each do 
      user = User.where(username: 'cR0nD0n')[0]
      user.remove
    end 
    it 'adds a users to the db' do
      count = User.all.length
      uc = UsersController.new(req,res,{'username': 'cR0nD0n', 'password': 'cR0nD0n'})
      uc.create
      expect(User.all.length).to eq(count + 1)
    end 
  end 
end
