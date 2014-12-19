class MessagesController < ApplicationController
  include SessionsHelper
  include InboxesHelper

  def create
    @message = Message.new(params[:message])
    @convo = current_node.initialized_convo(session[:receiver])
    @unread = Node.find(receiver).unreads.build
    @unread.update_attributes(:convo_id => @convo.id)
    @message = @convo.messages.build(params[])
    @message.update_attributes(:read => false, :receiver_id => receiver, :sender_id => self.id)
       if @message.save
         redirect_to :controller => 'inboxes', :action => 'show_messages',
                 :id => @convo.id, :errors => @message.errors.full_messages
       else
         redirect_to :controller => 'messages', :action => 'new',
                     :id => session[:receiver], :errors => @message.errors.full_messages
       end
  end

  def new
    @message = Message.new(params[:message])
    store_receiver(params[:id])
    store_location(params[:id], 'Message')
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


