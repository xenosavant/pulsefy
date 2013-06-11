class Connector < ActiveRecord::Base

  belongs_to :node, :counter_cache => true, :autosave => true
  attr_accessible   :strength
  include Network

  def defaults
    @strength = @@default_strength
  end

end