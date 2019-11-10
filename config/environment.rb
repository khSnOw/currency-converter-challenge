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

# Setting DataMapper database connection
DataMapper.setup(:default, 'mysql://root:db_password@db:3306/currency_database')

# configuration of currency converter
# Create a currency layer for Money
currency_layer = Money::Bank::CurrencylayerBank.new

# Set the API KEY
currency_layer.access_key = '2b3b0fa4a03034a15104c6e00b2d35a8'

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


# migrate database after loading all files
DataMapper.auto_upgrade!