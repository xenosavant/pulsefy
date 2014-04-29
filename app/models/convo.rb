class Convo < ActiveRecord::Base

  belongs_to :dialogue
  has_many :messages, :dependent => :destroy
  attr_accessible :interrogator_id, :interlocutor_id, :active, :unread_interrogator,
                  :unread_receiver
  default_scope order 'convos.created_at DESC'

end