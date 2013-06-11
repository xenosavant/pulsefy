class StaticController < ApplicationController
  include SessionsHelper

def home
  if signed_in?
  @node = current_node
  @pulse = current_node.pulses.new
  end
end

end