class ApplicationController < Sinatra::Base
  # This configuration part will inform the app where to search for the views and from where it will serve the static files
  configure do
    set :views, "app/views"
    set :public_dir, "app/public"
  end
  # use api helpers to generate responses in a specific format
  helpers ApiHelpers

  # handle not  found error by redirecting to /
  not_found do
    redirect to("/")
  end

  #return the home page
  get '/' do
    erb :index
  end

  #  return the page of conversion form
  get "/currency/convert" do
    erb :convert_form
  end

  # the endpoint for  converting then saving
  post "/currency/convert" do
    # the response will be in Json
    content_type :json
    # in case if the request is read by a middleware rewind
    request.body.rewind
    # parse request
    request_payload = JSON.parse(request.body.read)
    from = request_payload["from"]
    to = request_payload["to"]
    amount = request_payload["value"]
    # request validation
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

  # return history to table
  post "/currency/history" do
    # response format is json
		content_type :json
    # rewind the request body if it is read by a middleware
    request.body.rewind
    # parse request and do the validation
		request_payload = JSON.parse(request.body.read)
    begin
      size = Integer(request_payload["size"])
      page = Integer(request_payload["page"])
    rescue TypeError, ArgumentError
      size = 5
      page = 1
    end
		offset = (page - 1) * size
    # get the total count of saved conversion for pagination purposes
    total_count = CurrencyConvertHistory.all.count
    # get from database all necessary data
    query_result = CurrencyConvertHistory.all(:offset => offset, :limit => size,:order => [ :created_at.desc ])
    # return response
    JSON({:count => total_count , :rows => query_result})
  end

end