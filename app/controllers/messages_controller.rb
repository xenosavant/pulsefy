class MessagesController < ApplicationController
  include SessionsHelper
  include InboxesHelper

  def create
    if session[:receiver] != current_node.id
    @node = Node.find(session[:receiver])
    case current_node.dialogues.where(:receiver_id => @node.id).exists? or current_node.dialogues.where(:sender_id => @node.id).exists?
      when false
        @dialogue = current_node.dialogues.build
        @dialogue.update_attributes(:sender_id => current_node.id, :receiver_id => @node.id, :unread_receiver => true, :unread_sender => false)
        @node.dialogues << @dialogue
        current_node << @dialogue
      when true
        if current_node.dialogues.where(:receiver_id => @node.id).first.exists?
            @dialogue = current_node.dialogues.where(:receiver_id => @node.id).first
            @dialogue.update_attributes(:unread_receiver => true)
          else if current_node.dialogues.where(:sender_id => @node.id).first.exists?
            @dialogue = current_node.dialogues.where(:sender_id => @node.id).first
            @dialogue.update_attributes(:unread_sender => true)
          end
        end
      end
    end
    @dialogue.save
    case @dialogue.convos.any?
      when true
        case @dialogue.convos.where(:active => true).last.nil?
          when false
            @old_convo = @dialogue.convos.where(:active => true).last
            if Time.now - @old_convo.created_at > 12.hours
              @old_convo.update_attributes(:active => false)
              @old_convo.save
              @convo = @dialogue.convos.build
              @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => current_node.id,
                                       :unread_interrogator => false, :unread_interlocutor => true, :active => true)
              @convo.save
            else
              @convo = @dialogue.convos.where(:active => true).last
              if @convo.interlocutor_id == current_node.id
                 @convo.update_attributes(:unread_interrogator => true)
              else
                 @convo.update_attributes(:unread_interlocutor => true)
              end
            end
          else
            @convo = @dialogue.convos.build
            @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => current_node.id,
                                     :unread_interrogator => false, :unread_interlocutor => true, :active => true)
            @convo.save
          end
      else
        @convo = @dialogue.convos.build
        @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => current_node.id,
                                 :unread_interrogator => false, :unread_interlocutor => true, :active => true)
        @convo.save
    end
    @message = @convo.messages.build(params[:message])
    @message.update_attributes(:read => false, :receiver_id => @node.id, :sender_id => current_node.id)
    @message.save
    if @message.save
     redirect_to :controller => 'inboxes', :action => 'show_messages',
                :id => @convo.id, :errors => @message.errors.full_messages
     update_unreads(:node => @node)
    else return_back_to
    end
end

  def new
    @message = Message.new
    @node =  Node.find(session[:receiver])
  end

  def update
    @message = Message.find(params[:id])
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
  end


end


