class Dialogue < ActiveRecord::Base

  has_and_belongs_to_many :nodes
  attr_accessible :receiver_id, :sender_id, :unread_sender, :unread_receiver,
                  :sender_has_cookie, :receiver_has_cookie, :db_key, :cookie_key
  has_many :convos, :dependent => :destroy
  default_scope order 'dialogues.updated_at DESC'
  include SessionsHelper

  def refresh(node)
    if self.sender_id == node.id
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

  def set_encryption
    self.db_key = AES.key
    self.cookie_name = self.sender_id.to_s + '_' + self.receiver_id.to_s
    @set_encryption = AES.key
  end
end