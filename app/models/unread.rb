class Unread < ActiveRecord::Base

  belongs_to :node
  attr_accessible :convo_id

end
