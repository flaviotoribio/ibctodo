class ApiController < ApplicationController
  include ExceptionHandler

  respond_to :json
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
end
