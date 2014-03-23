
def new
  @dialogue = Dialogue.new
end

def update
  @dialogue = Message.find(params[:id])
end

def destroy
  @dialogue = Message.find(params[:id])
  @dialogue.destroy
  redirect_to :controller => 'inboxes', :action => 'show_dialogues', :id => current_node.id
end
