require_relative '../db/migration'
class UsersMigration < Migration
  create_table 'users' do |t|
    t.string 'username'
  end
end

UsersMigration.run

