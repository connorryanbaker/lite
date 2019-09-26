require_relative '../sandbox/sessions_controller'
require_relative '../models/app/user'
require 'rack'

describe 'SessionsController' do

  describe '#create' do
    let(:env) { {'rack.input' => ''} }
    let(:req) { Rack::Request.new(env) }
    let(:res) { Rack::Response.new([],200,{}) }
    before :each do
      User.new(username: 'cr0nD0n', password: 'cr0nD0n').save
    end

    after :each do
      User.where(username: 'cr0nD0n')[0].remove
    end

    it 'sets a cookie in the response' do
      sc = SessionsController.new(req,res,{username: 'cr0nD0n',
                                      password: 'cr0nD0n'})
      sc.invoke_action(:create)
      expect(res.headers['Set-Cookie']).to include('_rails_lite_app')
    end
  end

  describe '#destroy' do
    let(:env) { Rack::MockRequest.env_for('/') }
    let(:req) { Rack::Request.new(env) }
    let(:res) { Rack::Response.new([],200,{}) }
    it 'resets the users token and sets key in the cookie to nil' do
      env['rack.request.cookie_hash'] = "{\"_rails_lite_app\":\"key=123abc\"}"
      sc = SessionsController.new(req, res)
      sc.invoke_action(:destroy)
      app_cookie = res.headers['Set-Cookie'].split('=')[1]
      expect(app_cookie =~ /key/).to be(nil)
    end 
  end
end
