class InboxesController < ApplicationController
  include SessionsHelper
  include InboxesHelper
  include ActionController::Cookies

  def show_dialogues
    @node = current_node
    @node.received_dialogues.find_each do |d|
      if d.receiver_has_cookie == false
        get_secret(d)
      end
    end
    @dialogues = @node.dialogues
                     .paginate(:page => params[:page])
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
    store_receiver(Convo.find(params[:id]).refresh(current_node))
    @decrypted = []
    @encrypted_messages = Convo.find(params[:id]).messages
    key = cookies[Convo.find(params[:id]).dialogue.cookie_name] ||= nil
    @encrypted_messages.each do |m|
      if !key.nil?
        @message = Message.new(:content => AES.decrypt(m.content, key),
                               :sender_id => m.sender_id, :receiver_id => m.receiver_id)
        @decrypted << @message
      else
        @decrypted << Message.new(:content => 'You are not authorized to view this message',
                                  :sender_id => m.sender_id, :receiver_id => m.receiver_id)
      end
    end
    @messages = @decrypted.paginate(:page => params[:page])
  end

  def get_secret(dialogue)
    cookies.permanent[dialogue.cookie_name] = {value: dialogue.cookie_key}
    if cookies[dialogue.cookie_name]
      dialogue.update_attributes(:cookie_key => 'null', :receiver_has_cookie => true)
    else
      false
    end
  end

end
