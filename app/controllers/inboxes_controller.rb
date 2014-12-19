class InboxesController < ApplicationController
  include SessionsHelper
  include InboxesHelper

  def show_dialogues
    @node = current_node
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
    @convos = @dialogue.convos.paginate(:page => params[:page])
  end

  def show_messages
    @message = Message.new
    Convo.find(params[:id]).refresh(current_node)
    @messages = @convo.messages.paginate(:page => params[:page])
  end


end
