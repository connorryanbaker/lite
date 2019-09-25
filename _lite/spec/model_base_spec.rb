require_relative '../models/model_base'
require_relative '../models/app/user'
require_relative '../db/db_connection'

describe ModelBase do
  describe '#remove' do
    before :each do
      User.new(username: 'shabba').save
    end 
    
    it 'removes a record from the table' do
      count = User.all.length
      shabba = User.where(username: 'shabba')[0]
      shabba.remove
      expect(User.all.length).to eq(count - 1)
    end 
  end 
end 
