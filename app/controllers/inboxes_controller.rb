class InboxesController < ApplicationController
  include SessionsHelper

  def show_dialogues
    @node = current_node
    store_location(current_node.id, 'Inbox')
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
    @convos = Convo.where(:dialogue_id => params[:id]).paginate(:page => params[:page])
  end

  def show_messages
    @message = Message.new
    @convo = Convo.find(params[:id])
    if @convo.interrogator_id = current_node.id
      @id = @convo.interlocutor_id
    else
      @id = @convo.interrogator_id
    end
    @node = Node.find(@id)
    store_mailbox(@convo.id, 'messages')
    store_receiver(@id)
    @messages = Message.where(:convo_id => params[:id]).paginate(:page => params[:page])
  end

  def route_mail
    case session[:mail_location].nil? || session[:mail_id].nil? || session[:mail_id] = 0
      when false
        case session[:mail_location]
          when 'convos'
            redirect_to :controller => 'inboxes', :action => 'show_conversations',
                        :id => session[:mail_id]
          when 'messages'
            redirect_to :controller => 'inboxes', :action => 'show_messages',
                        :id => session[:mail_id]
          else
            redirect_to :controller => 'inboxes', :action => 'show_dialogues'
        end
      else
        redirect_to :controller => 'inboxes', :action => 'show_dialogues'
    end
  end

end
