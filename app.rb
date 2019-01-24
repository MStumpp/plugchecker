# Requires the Gemfile
require 'bundler' ; Bundler.require

ENV["ENVIRONMENT"] = "development"

require ::File.expand_path("../config/environment", __FILE__)

require 'sinatra/base'
require "charge_compare/use_case/station_tariffs/show"
require "api/response_handler/v1/station_tariffs/show"
require "api/response_handler/error"





class App < Sinatra::Base
  get '/v1/stations/:station_id/station_tariffs' do |station_id|
    resource = ChargeCompare::UseCase::StationTariffs::Show.new(station_id: station_id).run
    Api::ResponseHandler::V1::StationTariffs::Show.new(resource).to_rack_response
  end
  
  set :show_exceptions, false
  set :raise_errors, false
  
  error do |error|
    Api::ResponseHandler::Error.new(error).to_rack_response
  end
end