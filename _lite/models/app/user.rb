require 'bcrypt'
require_relative '../model_base'
class User < ModelBase
  finalize!
  def initialize(params)
    params.each do |k,v|
      self.send("#{k}=", v)
    end
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    self.session_token = self.class.gen_session_token
  end

  def self.gen_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.authenticate(params)
    user = User.where(username: params[:username])[0]
    user && user.is_password?(params[:password]) ? user : nil
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  
  def reset_session_token!
    self.session_token = self.class.gen_session_token
    self.save
    self.session_token
  end
end
