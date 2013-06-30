class Vote < ActiveRecord::Base

  belongs_to :node
  attr_accessible :rating, :pulse_id

end
