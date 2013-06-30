class PulseCommentsController < ApplicationController

  def create
    @pulse = Pulse.find(session[:return_to])
    @pulse_comment = @pulse.pulse_comments.build(params[:pulse_comment])
    @pulse_comment.update_attributes(:commenter => current_node.id)
    @node = Node.find(@pulse_comment.commenter)
    redirect_to @pulse
  end

  def destroy
    @pulse_comment = PulseComment.find(params[:id])
    @pulse_comment.destroy
    redirect_to Pulse.find(session[:return_to])
  end

end
