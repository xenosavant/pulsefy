class MessagesController < ApplicationController
  include SessionsHelper
  include InboxesHelper

  def create
    @convo = init(current_node, session[:receiver])
    @unread = Node.find(session[:receiver]).unreads.build
    @unread.update_attributes(:convo_id => @convo.id)
    @message = @convo.messages.build(params[:message])
    @message.update_attributes(:read => false, :receiver_id => session[:receiver], :sender_id => current_node.id)
    if @message.save
      redirect_to :controller => 'inboxes', :action => 'show_messages',
                 :id => @convo.id, :errors => @message.errors.full_messages
    else
      redirect_to :controller => 'messages', :action => 'new',
                     :id => @node.id, :errors => @message.errors.full_messages
    end
  end

  def new
    @message = Message.new(params[:message])
    store_receiver(params[:id])
    @node =  Node.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
  end


end


