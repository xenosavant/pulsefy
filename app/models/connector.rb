class Connector < ActiveRecord::Base

  belongs_to :node, :counter_cache => true, :autosave => true
  attr_accessible   :strength, :output_node
  include Network

  def defaults
    @strength = @@default_strength
  end

end