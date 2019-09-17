require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns unless @columns.nil?
    col = DBConnection.instance.execute2(<<-SQL)
      SELECT *
      FROM #{self.table_name}
      LIMIT 1
    SQL
    @columns = col[0].map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |col|
      define_method("#{col}") { self.attributes[col] }
      define_method("#{col}=") { |val| self.attributes[col] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    res = DBConnection.execute(<<-SQL)
      SELECT *
      FROM #{self.table_name}
    SQL
    self.parse_all(res)
  end

  def self.parse_all(results)
    results.map {|params| self.send(:new, params)}
  end

  def self.find(id)
    res = DBConnection.execute(<<-SQL, id: id)
    SELECT *
    FROM #{self.table_name}
    WHERE id = :id
    SQL
    if res[0]
      return self.new(res[0])
    end
    nil
  end

  def initialize(params = {})
    params.each do |k, v|
      if !self.class.columns.include?(k.to_sym)
        raise Exception.new("unknown attribute '#{k}'")
      else
        self.send("#{k}=", v)
      end 
    end 
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map {|col| self.send("#{col}")}
  end

  def insert
    col_names = self.class.columns.join(", ")
    qs = self.class.columns.map {|e| "?"}.join(", ")
    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{qs})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    set = self.class.columns[1..-1].map do |col|
      "#{col} = ?"
    end
    DBConnection.execute(<<-SQL, *attribute_values[1..-1], id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set.join(", ")}
      WHERE
        id = ?
    SQL
  end

  def save
    self.id.nil? ? insert : update
  end
end
