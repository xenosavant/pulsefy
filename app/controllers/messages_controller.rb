class MessagesController < ApplicationController
  include SessionsHelper
  include InboxesHelper
  include ActionController::Cookies

  def create
    @convo = initialized_convo(session[:receiver], current_node)
    @node = Node.find(session[:receiver])
    case current_node.check_for_request(@convo.dialogue)
      when false
        case @node.check_for_request(@convo.dialogue)
          when true
            redirect_to :controller => 'inboxes', :action => 'show_dialogues',
                        :id => session[:receiver], :errors => ["Awaiting your authorization"]
          else
                 case  cookies[@convo.dialogue.cookie_name].nil?
                   when false
                     @message = @convo.messages.build(params[:message])
                     if !@message.content.blank?
                     @unread = Node.find(session[:receiver]).unreads.build
                     @unread.update_attributes(:convo_id => @convo.id)
                     @unencrypted_message = @message.content
                     @encrypted_message = encrypt(@unencrypted_message, @convo.dialogue)
                     @message.update_attributes(:content => @encrypted_message, :receiver_id => session[:receiver], :sender_id => current_node.id)
                     end
                     redirect_to :controller => 'inboxes', :action => 'show_messages',
                                 :id => @convo.id, :errors => @message.errors.full_messages

                  else
                    redirect_to :controller => 'inboxes', :action => 'show_dialogues',
                                   :id => session[:receiver], :errors => ['Secure connection has not yet been established']
                 end
        end
      else
        redirect_to :controller => 'inboxes', :action => 'show_dialogues',
                    :id => session[:receiver], :notice => "Request has been sent to  #{Node.find(session[:receiver]).username}"
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
          @dialogue.update_attributes(:sender_id => sender.id, :receiver_id => receiver,
                                      :unread_receiver => true, :unread_sender => false,
                                      :sender_has_cookie => false, :receiver_has_cookie => false)
          key = @dialogue.set_encryption(receiver)
          if set_secret(key, @dialogue)
            @dialogue.sender_has_cookie = true
            @dialogue.cookie_key = key
          end
          @request = Request.new
          @request.update_attributes(:sender_id => sender.id, :receiver_id => @node.id, :dialogue_id => @dialogue.id,
                                     :body => "#{sender.username} would like to open a secure dialogue with you.
                                      Do you accept?", :request_type => 'dialogue')
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
              @dialogue.update_attributes(:sender_id => sender.id, :receiver_id => receiver,
                                          :unread_receiver => true, :unread_sender => false,
                                          :sender_has_cookie => false, :receiver_has_cookie => false,
                                          :sender_is_authorized => false, :receiver_is_authorized => false)
              key = @dialogue.set_encryption(receiver)
              if set_secret(key, @dialogue)
                @dialogue.sender_has_cookie = true
                @dialogue.cookie_key = key
              end
              @request = Request.new
              @request.update_attributes(:sender_id => sender.id, :receiver_id => @node.id, :dialogue_id => @dialogue.id,
                                         :body => "#{sender.username} would like to open a secure dialogue with you.
                                      Do you accept?", :type => 'dialogue')
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
                  if Time.now - @old_convo.messages.last.created_at > 24.hours and @old_convo.messages.where(:sender_id => sender.id).exists?
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

  def encrypt(message, dialogue)
    iv = AES.iv(:base_64)
    key = cookies[dialogue.cookie_name]
    @encrypt = AES.encrypt(message, key, {:iv => iv})
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


