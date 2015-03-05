class MessagesController < ApplicationController
  include SessionsHelper
  include InboxesHelper
  include ActionController::Cookies

  def create
    @message = Message.new(params[:message])
    @convo = initialized_convo(session[:receiver], current_node)
    @unread = Node.find(session[:receiver]).unreads.build
    @unread.update_attributes(:convo_id => @convo.id)
    @encrypted_message = encrypt(params[:message], @convo.dialogue)
    @message = @convo.messages.build(:content => @encrypted_message)
    @message.update_attributes(:receiver_id => session[:receiver], :sender_id => current_node.id)
       if @message.save
         redirect_to :controller => 'inboxes', :action => 'show_messages',
                 :id => @convo.id, :errors => @message.errors.full_messages
       else
         redirect_to :controller => 'messages', :action => 'new',
                     :id => session[:receiver], :errors => @message.errors.full_messages
       end
  end

  def new
    @message = Message.new(params[:message])
    store_receiver(params[:id])
    store_location(params[:id], 'Message')
    @node =  Node.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
  end

  def initialized_convo(receiver, sender)
    if receiver !=  sender.id and receiver != 0 and !receiver.nil?
      @node = Node.find(receiver)
      case sender.sent_dialogues.where(:receiver_id => @node.id).exists? or sender.received_dialogues.where(:sender_id => @node.id).exists?
        when false
          @dialogue = sender.dialogues.build
          @dialogue.update_attributes(:sender_id => sender.id, :receiver_id => @node.id,
                                      :unread_receiver => true, :unread_sender => false,
                                      :sender_has_cookie => false, :receiver_has_cookie => false)
          @node.dialogues << @dialogue
          sender.dialogues << @dialogue
          key = @dialogue.set_encryption
          if set_secret(key, @dialogue)
            @dialogue.sender_has_cookie = true
            @dialogue.cookie_key = key
          end
        when true
          case sender.sent_dialogues.where(:receiver_id => @node.id).exists?
            when true
              @dialogue = sender.sent_dialogues.where(:receiver_id => @node.id).first
              @dialogue.update_attributes(:unread_receiver => true)
            when false
              @dialogue = sender.received_dialogues.where(:sender_id => @node.id).first
              @dialogue.update_attributes(:unread_sender => true)
            else
              @dialogue = sender.dialogues.build
              @dialogue.update_attributes(:sender_id => sender.id, :receiver_id => @node.id,
                                          :unread_receiver => true, :unread_sender => false,
                                          :sender_has_cookie => false, :receiver_has_cookie => false)
              @node.dialogues << @dialogue
              sender.dialogues << @dialogue
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
                    @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => sender.id,
                                             :unread_interrogator => false, :unread_interlocutor => true, :active => true)
                    @convo.save
                    @initialized_convo = @convo
                  else
                    @convo = @dialogue.convos.where(:active => true).last
                    if @convo.interlocutor_id == sender.id
                      @convo.update_attributes(:unread_interrogator => true)
                    else
                      @convo.update_attributes(:unread_interlocutor => true)
                    end
                    @convo.save
                    @initialized_convo = @convo
                  end
                else
                  @convo = @dialogue.convos.where(:active => true).last
                  if @convo.interlocutor_id == sender.id
                    @convo.update_attributes(:unread_interrogator => true)
                  else
                    @convo.update_attributes(:unread_interlocutor => true)
                  end
                  @convo.save
                  @initialized_convo = @convo
              end
            else
              @convo = @dialogue.convos.build
              @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => sender.id,
                                       :unread_interrogator => false, :unread_interlocutor => true, :active => true)
              @convo.save
              @initialized_convo = @convo
          end
        else
          @convo = @dialogue.convos.build
          @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => sender.id,
                                   :unread_interrogator => false, :unread_interlocutor => true, :active => true)
          @convo.save
          @initialized_convo = @convo
      end
    end
  end

  def encrypt(params, dialogue)
    iv = AES.iv(:base_64)
    key = cookies[dialogue.cookie_name]
    @encrypt = AES.encrypt(params['content'], key, {:iv => iv})
  end

  def set_secret(key, dialogue)
    cookies.permanent[dialogue.cookie_name] = {value: key}
    if cookies[dialogue.cookie_name]
      dialogue.update_attributes(:sender_has_cookie => true)
      true
    else
      false
    end
  end

end


