# frozen_string_literal: true

# Requires the Gemfile
require "bundler"
Bundler.require

ENV["ENVIRONMENT"] = "development"

require ::File.expand_path("../config/environment", __FILE__)

require "sinatra/base"
require "sinatra/cross_origin"

require "api/request_handler/v1/tariffs/show"
require "charge_compare/use_case/tariffs/show"
require "api/response_handler/v1/tariffs/show"

require "api/request_handler/v1/charge_prices/index"
require "charge_compare/use_case/charge_prices/index"
require "api/response_handler/v1/charge_prices/index"

require "api/response_handler/error"
require "newrelic_rpm"

class App < Sinatra::Base
  def parsed_request
    request.params.merge!(params)
    request
  end

  configure do
    enable :cross_origin
  end

  post "/v1/tariffs" do
    request_dto = Api::RequestHandler::V1::Tariffs::Show.new(request: request).to_dto
    resource = ChargeCompare::UseCase::Tariffs::Show.new(request: request_dto).run
    Api::ResponseHandler::V1::Tariffs::Show.new(resource).to_rack_response
  end

  post "/v1/charge_prices" do
    request_dto = Api::RequestHandler::V1::ChargePrices::Index.new(request: request).to_dto
    response_dto = ChargeCompare::UseCase::ChargePrices::Index.new(request_dto).run
    Api::ResponseHandler::V1::ChargePrices::Index.new(response_dto.charge_prices).to_rack_response
  end

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    headers = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Headers"] = headers
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end

  get "/check" do
    [200, { "Access-Control-Allow-Origin" => "*" }, ["OK"]]
  end

  set :show_exceptions, false
  set :raise_errors, false

  error do |error|
    Api::ResponseHandler::Error.new(error).to_rack_response
  end
end
