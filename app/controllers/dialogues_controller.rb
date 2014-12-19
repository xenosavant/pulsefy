class DialoguesController < ApplicationController

def new
  @dialogue = Dialogue.new
end

def update
  @dialogue = Dialogue.find_self(params[:id])
end

def destroy
  @dialogue = Dialogue.find(params[:id])
  @dialogue.destroy
  redirect_to :controller => 'inboxes', :action => 'show_dialogues', :id => current_node.id
end

end