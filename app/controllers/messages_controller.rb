class MessagesController < ApplicationController
  include SessionsHelper

  def create
    if session[:receiver] != current_node.id
    @node = Node.find(session[:receiver])
    case !current_node.dialogues.where(:receiver_id => @node.id).exists? and !@node.dialogues.where(:receiver_id => current_node.id).exists?
      when true
        @dialogue = current_node.dialogues.build
        @dialogue.update_attributes(:receiver_id => @node.id)
      when false
        if current_node.dialogues.where(:receiver_id => @node.id).exists?
            @dialogue = current_node.dialogues.find_by_receiver_id(@node.id)
          else if @node.dialogues.where(:receiver_id => current_node.id).exists?
            @dialogue = @node.dialogues.find_by_receiver_id(current_node.id)
              end
        end
    end
    @dialogue.save
    case @dialogue.convos.any?
      when true
        case Convo.where('dialogue_id = ? AND active = ?', @dialogue.id, 1).first.nil?
          when false
            @old_convo = Convo.where('dialogue_id = ? AND active = ?', @dialogue.id, 1).first
            if Time.now - @old_convo.created_at > 12.hours
              @old_convo.update_attributes(:active => 0)
              @old_convo.save
              @convo = @dialogue.convos.build
              @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => current_node.id, :active => 1)
              @convo.save
            else
              @convo = @dialogue.convos.where(:active => true).last
            end
          else
            @convo = @dialogue.convos.build
            @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => current_node.id, :active => 1)
            @convo.save
          end
      else
        @convo = @dialogue.convos.build
        @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => current_node.id, :active => 1)
        @convo.save
    end
    @message = @convo.messages.build(params[:message])
    @message.update_attributes(:read => false, :receiver_id => @node.id, :sender_id => current_node.id)
    @message.save
    if @message.save
     redirect_to :controller => 'inboxes', :action => 'show_messages',
                :id => @convo.id, :errors => @message.errors.full_messages
    else return_back_to
    end
    else return_back_to
    end
  end

  def new
    @message = Message.new
    @node =  Node.find(session[:receiver]);
  end

  def update
    @message = Message.find(params[:id])
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
  end


end


