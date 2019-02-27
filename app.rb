# frozen_string_literal: true

# Requires the Gemfile
require "bundler"
Bundler.require

ENV["ENVIRONMENT"] = "development"

require ::File.expand_path("../config/environment", __FILE__)

require "sinatra/base"
require "api/request_handler/v1/tariffs/show"
require "charge_compare/use_case/tariffs/show"
require "api/response_handler/v1/tariffs/show"
require "api/response_handler/error"

class App < Sinatra::Base
  def parsed_request
    request.params.merge!(params)
    request
  end

  post "/v1/tariffs" do
    request_dto = Api::RequestHandler::V1::Tariffs::Show.new(request: request).to_dto
    resource = ChargeCompare::UseCase::Tariffs::Show.new(request: request_dto).run
    Api::ResponseHandler::V1::Tariffs::Show.new(resource).to_rack_response
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
