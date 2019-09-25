require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'byebug'
require_relative './session'


class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params = {})
    @req, @res, @params = req, res, params.merge(req.params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise if already_built_response?
    @res.location = url
    @res.status = 302
    session.store_session(@res)
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    session.store_session(@res)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.to_s.underscore
    path = "/views/#{controller_name}/#{template_name}.html.erb"
    full_path = File.join(File.dirname(__dir__), path)
    template = ERB.new(File.read(full_path))
    @template = template.result(binding)
    final_path = File.join(File.dirname(__dir__), "/views/base.html.erb")
    final = ERB.new(File.read(final_path))
    render_content(final.result(binding), 'text/html')
  end
  

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    #if self.class.protect_from_forgery && req.request_method != 'GET'
    # check_authenticity_token
    #end
    self.send(name)
    render(name) unless already_built_response?
  end
  
  def check_authenticity_token
		raise 'Invalid authenticity token' unless req.cookies['authenticity_token']
	end 
  
  def form_authenticity_token
    @auth_token ||= SecureRandom::urlsafe_base64
		res.set_cookie('authenticity_token', @auth_token)
    @auth_token
  end 
  
  def self.protect_from_forgery
    @@protect_from_forgery ||= true
  end 
end

