class Convo < ActiveRecord::Base

  belongs_to :dialogue
  has_many :messages
  attr_accessible :interrogator_id, :interlocutor_id
  default_scope order 'convos.created_at DESC'

end