class ApplicationController < Sinatra::Base
  # This configuration part will inform the app where to search for the views and from where it will serve the static files
  configure do
    set :views, "app/views"
    set :public_dir, "app/public"
  end
  helpers ApiHelpers

  #return the index
  get '/' do
    erb :index
  end
  #  return the page of conversion form
  get "/currency/convert" do
    erb :convert_form
  end

  # the endpoint for saving and converting
  post "/currency/convert" do
    # the response will be in Json
    content_type :json
    # in case if the request is read by a middleware rewind
    request.body.rewind
    # check the body state
    request_payload = JSON.parse(request.body.read)
    from = request_payload["from"]
    to = request_payload["to"]
    amount = request_payload["value"]
    begin
      amount = Float(amount)
      if from == nil or to == nil or amount == nil or  amount <= 0
        status 400
        generate_response("BAD REQUEST", false)
      elsif not %w(EUR CHF USD).include? from or not %w(EUR CHF USD).include? to
        status 400
        generate_response("NOT SUPPORTED CURRENCY", false)
      else
        begin
          # Try to convert and save
          result = Money.new(amount, from).exchange_to(to).to_f * 100
          # Conversion done Try to store
          history_item = CurrencyConvertHistory.create(
              :from => from,
              :to => to,
              :value => amount,
              :result => result)
          history_item.save
          generate_response(result, true)
        rescue StandardError
          status 400
          generate_response("ERROR OCCURRED! TRY LATER", false)
        end
      end
    rescue ArgumentError
      status 400
      generate_response("BAD REQUEST", false)
    end

  end

  # return the currency conversion history
  get "/currency/history" do
    erb :convert_history
  end

  # return data
  post "/currency/history" do
		content_type :json
    request.body.rewind

		request_payload = JSON.parse(request.body.read)
    begin
      size = Integer(request_payload["size"])
      page = Integer(request_payload["page"])
    rescue TypeError, ArgumentError
      size = 5
      page = 1
    end
		offset = (page - 1) * size
    total_count = CurrencyConvertHistory.all.count
    query_result = CurrencyConvertHistory.all(:offset => offset, :limit => size,:order => [ :created_at.desc ])
    JSON({:count => total_count , :rows => query_result})
  end

end