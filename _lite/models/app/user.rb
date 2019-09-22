require_relative '../model_base'
class User < SQLObject
  self.finalize!
end
