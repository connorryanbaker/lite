require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies['_rails_lite_app']
      cookies = req.cookies['_rails_lite_app']
      @cookie = {}
      k, v = cookies.split('=')
      @cookie[k.to_sym] = v
    else
      @cookie = {}
    end 
  end

  def [](key)
    @cookie[key.to_sym]
  end

  def []=(key, val)
    @cookie[key.to_sym] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    cookie_str = @cookie.reject {|_,v| v.nil?}.to_json
    res.set_cookie('_rails_lite_app', { path: '/',
                                        value: cookie_str })
  end
end
