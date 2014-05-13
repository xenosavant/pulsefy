class Dialogue < ActiveRecord::Base

  has_and_belongs_to_many :nodes
  attr_accessible :receiver_id, :sender_id, :unread_sender, :unread_receiver
  has_many :convos, :dependent => :destroy
  default_scope order 'dialogues.updated_at DESC'

end