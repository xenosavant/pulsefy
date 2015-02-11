class Repulse < ActiveRecord::Base

  belongs_to :node
  attr_accessible :pulse_id

end
