class InboxesController < ApplicationController

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
    store_location(params[:id], 'Inbox')
    @convos = Convo.where(:dialogue_id => params[:id]).paginate(:page => params[:page])
  end

  def show_messages
    @message = Message.new
    @convo = Convo.find(params[:id])
    store_location(params[:id], 'Inbox')
    if @convo.interlocutor_id = current_node.id
      store_receiver(@convo.interrogator_id)
    else
      store_receiver(@convo.interlocutor_id)
    end
    @messages = Message.where(:convo_id => params[:id]).paginate(:page => params[:page])
  end

end
