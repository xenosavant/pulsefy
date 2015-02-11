class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def handle_unverified_request
    sign_out
    super
  end

  def is_an_admin?
    case @check = current_node.admin
      when true
        true
      else
        false
    end
  end

end
