class MessagesController < ApplicationController
  include SessionsHelper
  include InboxesHelper

  def create
    @message = Message.new(params[:message])
    case params[:message]
      when true
       @convo = current_node.initialize_convo(session[:receiver])
       @unread = Node.find(session[:receiver]).unreads.build
       @unread.update_attributes(:convo_id => @convo.id)
       @message = @convo.messages.build(params[:message])
       @message.update_attributes(:read => false, :receiver_id => session[:receiver], :sender_id => current_node.id)
       @message.save
       if @message.save
         redirect_to :controller => 'inboxes', :action => 'show_messages',
                 :id => @convo.id, :errors => @message.errors.full_messages
       else
         redirect_to :controller => 'messages', :action => 'new', :id => session[:receiver]
        end
      else
        redirect_to :controller => 'messages', :action => 'new', :id => session[:receiver]
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


