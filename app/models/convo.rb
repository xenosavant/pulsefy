class Convo < ActiveRecord::Base

  belongs_to :dialogue
  has_many :messages, :dependent => :destroy
  attr_accessible :interrogator_id, :interlocutor_id, :active, :unread_interrogator,
                  :unread_interlocutor
  default_scope order 'convos.created_at DESC'
  Include SessionsHelper

  def refresh
    if self.interrogator_id == @node.id
      @id = self.interlocutor_id
      case self.unread_interrogator
        when true
          self.update_attributes(:unread_interrogator => false)
          current_node.unreads.where("convo_id = ?", self.id).each do |unread|
            unread.delete
          end
      end
   else
     @id = self.interrogator_id
     case self.unread_interlocutor
      when true
        self.update_attributes(:unread_interlocutor => false)
        current_node.unreads.where("convo_id = ?", self.id).each do |unread|
          unread.delete
        end
      end
   end
   store_reciever(@id)
   store_mailbox(self.id, 'messages')
   Dialogue.find(self.dialogue_id).refresh
  end

end