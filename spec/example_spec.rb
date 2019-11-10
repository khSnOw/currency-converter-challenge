require 'spec_helper'

describe 'Your application' do

  it "Index page works!" do
    get '/'
    expect(last_response.status).to eq 200
  end

  it "Currency exchange form page works !" do
    get "/currency/convert"
    expect(last_response.status).to eq 200
  end

  it "Currency history  page works !" do
    get "/currency/history"
    expect(last_response.status).to eq 200
  end


  it "Currency create with wrong from param" do
    mock_reuest = {:from => "EURORO", :to=> "USD", :value => "25.3" }
    post("/currency/convert", JSON(mock_reuest) , { 'CONTENT_TYPE' => 'application/json' })
    expect(last_response.status).to eq 400
  end

  it "Currency create with wrong to param" do
    mock_reuest = {:from => "EUR", :to=> "USDEE", :value => "25.3" }
    post("/currency/convert", JSON(mock_reuest) , { 'CONTENT_TYPE' => 'application/json' })
    expect(last_response.status).to eq 400
  end

  it "Currency create with a not covered currency by this application" do
    mock_reuest = {:from => "EUR", :to=> "TND", :value => "25.3" }
    post("/currency/convert", JSON(mock_reuest) , { 'CONTENT_TYPE' => 'application/json' })
    expect(last_response.status).to eq 400
  end

  it "Currency create with invalid  amount" do
    mock_reuest = {:from => "EUR", :to=> "TND", :value => "25.3eq" }
    post("/currency/convert", JSON(mock_reuest) , { 'CONTENT_TYPE' => 'application/json' })
    expect(last_response.status).to eq 400
  end

  it "Currency create with negative  amount" do
    mock_reuest = {:from => "EUR", :to=> "TND", :value => "-25.3" }
    post("/currency/convert", JSON(mock_reuest) , { 'CONTENT_TYPE' => 'application/json' })
    expect(last_response.status).to eq 400
  end

  it "Currency create with a correct format" do
    mock_reuest = {:from => "EUR", :to=> "USD", :value => "25.3" }
    post("/currency/convert", JSON(mock_reuest) , { 'CONTENT_TYPE' => 'application/json' })
    expect(last_response.status).to eq 200
  end

  # for history datatable I choose to return always a result
  # even if the parameters are wrong by using default values
  it "Check history get " do
    mock_reuest = {:size => "10", :page=> "1" }
    post("/currency/history", JSON(mock_reuest) , { 'CONTENT_TYPE' => 'application/json' })
    expect(last_response.status).to eq 200
  end
  it 'Check respecting paging params' do
    mock_reuest = {:size => "20", :page=> "1" }
    post("/currency/history", JSON(mock_reuest) , { 'CONTENT_TYPE' => 'application/json' })
    expect(last_response.status).to eq 200
    result = JSON.parse(last_response.body)["rows"]
    expect(result.length).to be <= 20
  end




end