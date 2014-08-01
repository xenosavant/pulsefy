class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  require 'will_paginate/array'

  def handle_unverified_request
    sign_out
    super
  end

end
