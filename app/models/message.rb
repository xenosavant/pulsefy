class Message < ActiveRecord::Base

  belongs_to :convo
  attr_accessible :content, :sender_id, :receiver_id
  validates :content, :presence => true, :length => { :maximum => 1000 }

  default_scope order 'messages.created_at ASC'

end
