class Convo < ActiveRecord::Base

  belongs_to :dialogue
  has_many :messages, :dependent => :destroy
  attr_accessible :interrogator_id, :interlocutor_id, :active, :unread_interrogator,
                  :unread_interlocutor
  default_scope order 'convos.created_at DESC'
  include SessionsHelper

  def refresh(node)
    if self.interrogator_id == node.id
      @id = self.interlocutor_id
      case self.unread_interrogator
        when true
          self.update_attributes(:unread_interrogator => false)
          Unread.where("convo_id = ? AND node_id = ?", self.id, self.interrogator_id).each do |unread|
            unread.delete
          end
      end
   else
     @id = self.interrogator_id
     case self.unread_interlocutor
      when true
        self.update_attributes(:unread_interlocutor => false)
        Unread.where("convo_id = ? AND node_id = ?", self.id, self.interlocutor_id).each do |unread|
          unread.delete
        end
      end
   end
   Dialogue.find(self.dialogue_id).refresh(node)
  end

end