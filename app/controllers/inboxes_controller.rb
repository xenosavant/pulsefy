class InboxesController < ApplicationController

  def show_dialogues
    @node = current_node
    case @node.dialogues.any?
      when true
        if Dialogue.where(:receiver_id => current_node.id).nil?
           @sum = @node.dialogues
        else
           @sum = @node.dialogues + Dialogue.where(:receiver_id => current_node.id)
        end
      when false
        if !Dialogue.where(:receiver_id => current_node.id).nil?
          @sum = Dialogue.where(:receiver_id => current_node.id)
        else
          @sum = nil
        end
    end
    if @sum.nil?
      @dialogues= nil
    else
      @d = @sum.sort_by! {|a| a[:updated_at] }
      @d = @d.reverse
      @dialogues = @d.paginate(:page => params[:page])
    end
  end

  def show_convos
    @dialogue = Dialogue.find(params[:id])
    @convos = Convo.where(:dialogue_id => params[:id]).paginate(:page => params[:page])
  end

  def show_messages
    @message = Message.new
    @convo = Convo.find(params[:id])
    store_location(params[:id], 'Inbox')
    @messages = Message.where(:convo_id => params[:id]).paginate(:page => params[:page])
  end

end
