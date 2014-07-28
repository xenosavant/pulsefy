class PulseCommentsController < ApplicationController

  include ApplicationHelper

  def create
    @pulse = Pulse.find(session[:return_to])
    @pulse_comment = @pulse.pulse_comments.build(params[:pulse_comment])
    @pulse_comment.update_attributes(:commenter => current_node.id)
    @node = Node.find(@pulse_comment.commenter)
    parse_content(:object => @pulse_comment)
    redirect_to @pulse
  end

  def destroy
    case PulseComment.find(params[:id]).nil?
      when false
         @pulse_comment = PulseComment.find(params[:id])
         @pulse_comment.destroy
    end
    redirect_to @pulse
  end

end
