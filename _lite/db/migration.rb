require_relative 'db_connection'
require 'byebug'
class Migration
  attr_reader :create_command

  def change
  end

  def self.create_table(name, &block)
    iterator = MigrationIterator.new
    debugger
    block.call(iterator)
    gen_create_query(name, iterator.columns)
  end

  def self.gen_create_query(name, hash)
    debugger
    @create_command = "CREATE TABLE IF NOT EXISTS #{name} (#{gen_column_str(hash)});"
  end

  def self.gen_column_str(hash)
    hash.map {|k,v| "#{k} #{v} NOT NULL"}.join(', ')
  end

  def self.run
    raise 'create table string not yet generated' unless @create_command
    DBConnection.execute(@create_command)
  end
end

class MigrationIterator
  attr_reader :columns
  def initialize
    @columns = {}
  end

  def string(col_name)
    columns[col_name] = 'string'
  end

  def integer(col_name)
    columns[col_name] = 'integer'
  end

  def [](key)
    columns[key]
  end

  def []=(key, val)
    columns[key] = val
  end
end
