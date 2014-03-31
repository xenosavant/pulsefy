class InboxesController < ApplicationController
  include SessionsHelper

  def show_dialogues
    @node = current_node
    store_location(current_node.id, 'Inbox')
    case @node.dialogues.any?
      when true
        if Dialogue.where(:receiver_id => @node.id).nil?
           @sum = @node.dialogues
        else
           @sum = @node.dialogues + Dialogue.where(:receiver_id => @node.id)
        end
      when false
        if !Dialogue.where(:receiver_id => @node.id).nil?
          @sum = Dialogue.where(:receiver_id => @node.id)
        else
          @sum = nil
        end
    end
    if @sum.nil?
      @d= nil
    else
      @d = @sum
      @dialogues = @d.paginate(:page => params[:page])
    end
  end

  def show_convos
    @dialogue = Dialogue.find(params[:id])
    store_location(current_node.id, 'Inbox')
    if @dialogue.receiver_id = current_node.id
      @id = @dialogue.node_id
    else
      @id = @dialogue.receiver_id
    end
    store_receiver(@id)
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
    store_location(@id, 'Inbox')
    store_receiver(@id)
    @messages = Message.where(:convo_id => params[:id]).paginate(:page => params[:page])
  end

end
