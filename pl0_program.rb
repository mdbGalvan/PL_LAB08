require 'data_mapper'
# full path!
DataMapper.setup(:default, 
                 ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/database.db" )

# Models Login
class Login
  include DataMapper::Resource
  
  property :user, String, :key => true

  has n, :pL0Programs
end

# Models PL0Program
class PL0Program
  include DataMapper::Resource
  
  property :name, String, :key => true
  property :user, String, :key => true
  property :source, String, :length => 1..1024
  
  belongs_to :login  # defaults to :required => true # Cannot be nil
end

DataMapper.finalize			# This checks the models for validity and initializes all properties associated with relationships
DataMapper.auto_upgrade!	# This tries to make the schema match the model. It will CREATE new tables, and add columns to existing tables