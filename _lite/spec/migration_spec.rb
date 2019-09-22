require_relative '../db/migration'

describe MigrationIterator do
  let(:iterator) { MigrationIterator.new }

  describe '#columns' do
    it 'is a hash' do
      expect(iterator.columns).to be_a(Hash)
    end

    it 'is getable and setable' do
      iterator['hola'] = 'cunao'
      expect(iterator['hola']).to eq('cunao')
    end
  end

  describe '#string' do
    it 'sets a key in columns equal to its argument, pointing to string' do
      iterator.string('username')
      expect(iterator['username']).to eq('string')
    end
  end

  describe '#integer' do
    it 'sets a key in columns equal to its argument, pointing to integer' do
      iterator.integer('team_id')
      expect(iterator['team_id']).to eq('integer')
    end
  end
end

describe Migration do
  let(:migration) { Migration.new }
  let(:hash) { { 'name': 'string', 'id': 'integer' } }

  describe '#gen_column_str' do
    it 'takes a hash and returns comma separated string of columnnames and types' do
      expect(Migration.gen_column_str(hash)).to be_a(String)
      expect(Migration.gen_column_str(hash)).to eq('name string NOT NULL, id integer NOT NULL')
    end
  end

  describe '#gen_create_query' do
    it 'takes a table name and column hash, returning a string' do
      expect(Migration.gen_create_query('users',{ 'name': 'string' })).to be_a(String)
    end

    it 'returns a create_table sql statement' do
      expect(Migration.gen_create_query('users', { 'name': 'string' })).to eq('CREATE TABLE IF NOT EXISTS users (name string NOT NULL);')
    end
  end
end
