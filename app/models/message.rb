class Message < ActiveRecord::Base

  belongs_to :convo
  attr_accessible :content, :sender_id, :receiver_id
  validates :content, :presence => true, :length => { :maximum => 2500 }
  default_scope order 'messages.created_at DESC'


  def current_sender
    @current_sender = Node.find(self.sender_id)
  end

  def init
    if session[:receiver] !=  current_node.id and session[:receiver] != 0 and !session[:receiver].nil?
      @node = Node.find(session[:receiver])
      case current_node.dialogues.where(:receiver_id => @node.id).exists? or current_node.dialogues.where(:sender_id => @node.id).exists?
        when false
          @dialogue = current_node.dialogues.build
          @dialogue.update_attributes(:sender_id => current_node.id, :receiver_id => @node.id, :unread_receiver => true, :unread_sender => false)
          @node.dialogues << @dialogue
          current_node.dialogues << @dialogue
        when true
          case current_node.dialogues.where(:receiver_id => @node.id).exists?
            when true
              @dialogue = current_node.dialogues.where(:receiver_id => @node.id).first
              @dialogue.update_attributes(:unread_receiver => true)
            when false
              @dialogue = current_node.dialogues.where(:sender_id => @node.id).first
              @dialogue.update_attributes(:unread_sender => true)
            else
              @dialogue = current_node.dialogues.build
              @dialogue.update_attributes(:sender_id => current_node.id, :receiver_id => @node.id, :unread_receiver => true, :unread_sender => false)
              @node.dialogues << @dialogue
              current_node.dialogues << @dialogue
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
                    @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => current_node.id,
                                             :unread_interrogator => false, :unread_interlocutor => true, :active => true)
                    @convo.save
                  else
                    @convo = @dialogue.convos.where(:active => true).last
                    if @convo.interlocutor_id == current_node.id
                      @convo.update_attributes(:unread_interrogator => true)
                    else
                      @convo.update_attributes(:unread_interlocutor => true)
                    end
                  end
                else
                  @convo = @dialogue.convos.where(:active => true).last
                  if @convo.interlocutor_id == current_node.id
                    @convo.update_attributes(:unread_interrogator => true)
                  else
                    @convo.update_attributes(:unread_interlocutor => true)
                  end
              end
            else
              @convo = @dialogue.convos.build
              @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => current_node.id,
                                       :unread_interrogator => false, :unread_interlocutor => true, :active => true)
              @convo.save
          end
        else
          @convo = @dialogue.convos.build
          @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => current_node.id,
                                   :unread_interrogator => false, :unread_interlocutor => true, :active => true)
          @convo.save
      end
      @message = @convo.messages.build(params[:message])
      @message.update_attributes(:read => false, :receiver_id => @node.id, :sender_id => current_node.id)
      @message.save
      case @node.unreads.where("convo_id = ?", @convo.id).first.nil?
        when true
          @unread = @node.unreads.build
          @unread.update_attributes(:convo_id => @convo.id)
      end
    end
  end


end
