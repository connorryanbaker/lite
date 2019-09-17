require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map {|k| "#{k} = ?"}.join(" AND ")
    res = DBConnection.execute(<<-SQL, *params.values)
      SELECT *
      FROM #{self.table_name}
      WHERE #{where_line}
    SQL
    return res[0] ? res.map {|r| self.send(:new, r)} : []
  end
end

class SQLObject
  extend Searchable
end
