class InboxesController < ApplicationController
  include SessionsHelper
  include InboxesHelper

  def show_dialogues
    @node = current_node
    @dialogues = @node.dialogues.paginate(:page => params[:page])
  end

  def show_convos
    @dialogue = Dialogue.find(params[:id])
    if @dialogue.receiver_id == current_node.id
      @id = @dialogue.sender_id
    else
      @id = @dialogue.receiver_id
    end
    store_receiver(@id)
    @convos = @dialogue.convos.paginate(:page => params[:page])
  end

  def show_messages
    @message = Message.new
    Convo.find(params[:id]).refresh(current_node)
    @messages = @convo.messages.paginate(:page => params[:page])
  end


end
