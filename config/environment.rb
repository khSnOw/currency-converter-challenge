# Setting the app envirement
ENV['SINATRA_ENV'] ||= "development"
ENV['RACK_ENV'] ||= "development"
# Add the needed requirement to boot the app
require 'bundler/setup'
require 'rubygems'
require 'data_mapper'
require  'dm-migrations'
Bundler.require(:default, ENV['SINATRA_ENV'])

# Attach database logging to the stdout
DataMapper::Logger.new($stdout, :debug)

# Setting DataMapper database connection
DataMapper.setup(:default, 'mysql://root:db_password@127.0.0.1:3306/currency_database')

# Loading all the files in app folder
require_all 'app'


# migrate database after loading all files
DataMapper.auto_migrate!