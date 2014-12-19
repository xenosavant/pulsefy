class MessagesController < ApplicationController
  include SessionsHelper
  include InboxesHelper

  def create
    Message.init
    if @message.save
      @message.add_unread
      redirect_to :controller => 'inboxes', :action => 'show_messages',
                 :id => @convo.id, :errors => @message.errors.full_messages
    else
      redirect_to :controller => 'messages', :action => 'new',
                     :id => @node.id, :errors => @message.errors.full_messages
    end
  end

  def new
    @message = Message.new
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


