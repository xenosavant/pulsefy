class InboxesController < ApplicationController
  include SessionsHelper
  include InboxesHelper

  def show_dialogues
    @node = current_node
    #case session[:mail_location].nil? || session[:mail_id].nil? || session[:mail_id] = 0
    #  when false
    #    case session[:mail_location]
    #      when 'convos'
    #        redirect_to :controller => 'inboxes', :action => 'show_conversations',
    #                    :id => session[:mail_id]
    #      when 'messages'
    #        redirect_to :controller => 'inboxes', :action => 'show_messages',
    #                    :id => session[:mail_id]
    #    end
    #end
    store_location(@node.id, 'Inbox')
    @dialogues = @node.dialogues.paginate(:page => params[:page])
  end

  def show_convos
    @node = current_node
    @dialogue = Dialogue.find(params[:id])
    if @dialogue.receiver_id == @node.id
      @id = @dialogue.sender_id
    else
      @id = @dialogue.receiver_id
    end
    store_receiver(@id)
    store_location(@dialogue.id, 'Inbox')
    store_mailbox(@dialogue.id, 'convos')
    @convos = @dialogue.convos.paginate(:page => params[:page])
  end

  def show_messages
    @node = Node.find(current_node.id)
    @message = Message.new
    @convo = Convo.find(params[:id])
    @dialogue = Dialogue.find(@convo.dialogue_id)
  if @convo.interrogator_id == @node.id
    @id = @convo.interlocutor_id
      case @convo.unread_interrogator
        when true
          @convo.update_attributes(:unread_interrogator => false)
          @unread = current_node.unreads.find_by_convo_id(@convo.id)
          @unread.delete
      end
  else
    @id = @convo.interrogator_id
      case @convo.unread_interlocutor
        when true
          @convo.update_attributes(:unread_interlocutor => false)
          @unread = current_node.unreads.find_by_convo_id(@convo.id)
          @unread.delete
      end
  end

    if @dialogue.sender_id == @node.id
      case @dialogue.unread_sender
        when true
          @dialogue.update_attributes(:unread_sender => false)
      end
    else
      case @dialogue.unread_receiver
        when true
          @dialogue.update_attributes(:unread_receiver => false)
      end
    end

    store_receiver(@id)
    store_mailbox(@convo.id, 'messages')
    @messages = @convo.messages.paginate(:page => params[:page])
  end
end
