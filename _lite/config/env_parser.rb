class EnvParser
  def self.check_form_vars(env)
    if env['rack.input'].methods.include?(:string)
      method = env['rack.input'].string.split('=')[1]
      env['REQUEST_METHOD'] = method
    end 
    env
  end 
end
