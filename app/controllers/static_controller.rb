class StaticController < ApplicationController
  include SessionsHelper

def home
  if signed_in?
  @node = current_node
  @pulse = current_node.pulses.new
  store_location(@node.id)
  @pulses = @node.pulses.paginate(:page => params[:page])
  end
end
end