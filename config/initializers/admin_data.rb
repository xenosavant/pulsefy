include ApplicationController
include SessionsHelper

AdminData.config do |config|
  config.is_allowed_to_view = lambda {|controller| return true if current_node.is_an_admin? }
  config.is_allowed_to_update = lambda {|controller| return true if current_node.is_an_admin? }
end