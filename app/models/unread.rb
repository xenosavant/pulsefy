class Unread < ActiveRecord::Base
  belongs_to :node
  belongs_to :dialogue
  attr_accessible :convo_id
end
