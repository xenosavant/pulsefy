class InboxesController < ApplicationController
  include SessionsHelper
  include InboxesHelper

  def show_dialogues
    @node = current_node
    store_location(current_node.id, 'Inbox')
    update_dialogues
    case session[:mail_location].nil? || session[:mail_id].nil? || session[:mail_id] = 0
      when false
        case session[:mail_location]
          when 'convos'
            redirect_to :controller => 'inboxes', :action => 'show_conversations',
                        :id => session[:mail_id]
          when 'messages'
            redirect_to :controller => 'inboxes', :action => 'show_messages',
                        :id => session[:mail_id]
        end
    end
    @dialogues = @node.dialogues.paginate(:page => params[:page])
  end

  def show_convos
    @dialogue = Dialogue.find(params[:id])
    store_location(@dialogue.id, 'Inbox')
    if @dialogue.receiver_id = current_node.id
      @id = @dialogue.node_id
    else
      @id = @dialogue.receiver_id
    end
    store_receiver(@id)
    store_mailbox(@dialogue.id, 'convos')
    @convos = @dialogue.convos.paginate(:page => params[:page])
  end

  def show_messages
    @message = Message.new
    @convo = Convo.find(params[:id])
    if @convo.interrogator_id == current_node.id
      @id = @convo.interlocutor_id
      @convo.update_attributes(:unread_by_interrogator => false)
    else
      @id = @convo.interrogator_id
      @convo.update_attributes(:unread_by_interlocutor => false)
    end
    @node = Node.find(@id)
    store_mailbox(@convo.id, 'messages')
    store_receiver(@id)
    @messages = @convo.messages.paginate(:page => params[:page])
  end
end
