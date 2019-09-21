require_relative 'db_connection'
class Migration
  def change
  end

  def create_table(name, &block)
    iterator = MigrationIterator.new
    block.call(iterator)
    gen_create_query(name, iterator.columns)
  end

  def gen_create_query(name, hash)
    "CREATE TABLE #{name} (#{gen_column_str(hash)});"
  end

  def gen_column_str(hash)
    hash.map {|k,v| "#{k} #{v} NOT NULL"}.join(', ')
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
