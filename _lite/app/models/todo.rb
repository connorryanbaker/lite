require_relative '../../models/model_base'
class Todo < ModelBase
  belongs_to :user
end