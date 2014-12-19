class Message < ActiveRecord::Base

  belongs_to :convo
  attr_accessible :content, :sender_id, :receiver_id
  validates :content, :presence => true, :length => { :maximum => 2500 }
  default_scope order 'messages.created_at DESC'


  def current_sender
    @current_sender = Node.find(self.sender_id)
  end

  def init(node, receiver)
    if receiver !=  node.id and receiver != 0 and !receiver.nil?
      @node = Node.find(receiver)
      case node.dialogues.where(:receiver_id => @node.id).exists? or node.dialogues.where(:sender_id => @node.id).exists?
        when false
          @dialogue = node.dialogues.build
          @dialogue.update_attributes(:sender_id => node.id, :receiver_id => @node.id, :unread_receiver => true, :unread_sender => false)
          @node.dialogues << @dialogue
          node.dialogues << @dialogue
        when true
          case node.dialogues.where(:receiver_id => @node.id).exists?
            when true
              @dialogue = node.dialogues.where(:receiver_id => @node.id).first
              @dialogue.update_attributes(:unread_receiver => true)
            when false
              @dialogue = node.dialogues.where(:sender_id => @node.id).first
              @dialogue.update_attributes(:unread_sender => true)
            else
              @dialogue = node.dialogues.build
              @dialogue.update_attributes(:sender_id => node.id, :receiver_id => @node.id, :unread_receiver => true, :unread_sender => false)
              @node.dialogues << @dialogue
              node.dialogues << @dialogue
          end
      end
      @dialogue.save
      case @dialogue.convos.any?
        when true
          case @dialogue.convos.where(:active => true).last.nil?
            when false
              @old_convo = @dialogue.convos.where(:active => true).last
              case @old_convo.messages.last.nil?
                when false
                  if Time.now - @old_convo.messages.last.created_at > 24.hours
                    @old_convo.update_attributes(:active => false)
                    @old_convo.save
                    @convo = @dialogue.convos.build
                    @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => node.id,
                                             :unread_interrogator => false, :unread_interlocutor => true, :active => true)
                    @init = @convo
                  else
                    @convo = @dialogue.convos.where(:active => true).last
                    if @convo.interlocutor_id == node.id
                      @convo.update_attributes(:unread_interrogator => true)
                    else
                      @convo.update_attributes(:unread_interlocutor => true)
                    end
                    @init = @convo
                  end
                else
                  @convo = @dialogue.convos.where(:active => true).last
                  if @convo.interlocutor_id == node.id
                    @convo.update_attributes(:unread_interrogator => true)
                  else
                    @convo.update_attributes(:unread_interlocutor => true)
                  end
                  @init = @convo
              end
            else
              @convo = @dialogue.convos.build
              @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => node.id,
                                       :unread_interrogator => false, :unread_interlocutor => true, :active => true)
              @init = @convo
          end
        else
          @convo = @dialogue.convos.build
          @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => node.id,
                                   :unread_interrogator => false, :unread_interlocutor => true, :active => true)
          @init = @convo
      end
    end
  end

end
