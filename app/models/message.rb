class Message < ActiveRecord::Base

  belongs_to :convo
  attr_accessible :read, :content, :sender_id, :receiver_id
  validates :content, :presence => true

  default_scope order 'messages.created_at ASC'

end
