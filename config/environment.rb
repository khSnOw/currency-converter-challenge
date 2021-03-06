# Setting the app environment
ENV['SINATRA_ENV'] ||= "development"
ENV['RACK_ENV'] ||= "development"
# Add the needed requirement to boot the app
require 'bundler/setup'
require 'rubygems'
require 'data_mapper'
require  'dm-migrations'
require 'money/bank/currencylayer_bank'
Bundler.require(:default, ENV['SINATRA_ENV'])

# Attach database logging to the stdout
DataMapper::Logger.new($stdout, :debug)



# configuration of currency converter
# Create a currency layer for Money
currency_layer = Money::Bank::CurrencylayerBank.new

# Set the API KEY
currency_layer.access_key = '339211f5d1202fe76e02bb6c3c50415e'

# Update Rates
currency_layer.update_rates

# set the currency layer to the Money instances
Money.default_bank = currency_layer

# set infinite precision to be more exact
Money.infinite_precision = true


# Loading all the files in app folder by order of call
require_all 'app/helpers'
require_all 'app/models'
require_all 'app/controllers'

# Setting DataMapper database connection and migrate database
begin
  # if you run from docker
  DataMapper.setup(:default, 'mysql://root:db_password@db:3306/currency_database')
  DataMapper.auto_upgrade!
rescue
  # if you run local 
  # you can change this string to match your own databse
  DataMapper.setup(:default, 'mysql://root:db_password@127.0.0.1:3306/currency_database')
  DataMapper.auto_upgrade!
end
