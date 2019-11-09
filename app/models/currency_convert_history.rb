class CurrencyConvertHistory
  include DataMapper::Resource

  property :id,         Serial
  property :from,       String
  property :to,         String
  property :value,      Float
  property :result,     Float
  property :created_at,  DateTime, :default => DateTime.now
end