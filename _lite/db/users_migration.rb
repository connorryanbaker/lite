require_relative 'migration'
class UsersMigration < Migration
  create_table 'users' do |t|
    t.string 'name'
  end
end

UsersMigration.run
