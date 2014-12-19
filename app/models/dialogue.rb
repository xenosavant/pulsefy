class Dialogue < ActiveRecord::Base

  has_and_belongs_to_many :nodes
  attr_accessible :receiver_id, :sender_id, :unread_sender, :unread_receiver
  has_many :convos, :dependent => :destroy
  default_scope order 'dialogues.updated_at DESC'


  def refresh
    if self.sender_id == current_node.id
      case self.unread_sender
        when true
          self.update_attributes(:unread_sender => false)
      end
    else
      case self.unread_receiver
        when true
          self.update_attributes(:unread_receiver => false)
      end
    end
  end
end