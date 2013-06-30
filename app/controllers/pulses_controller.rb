class PulsesController < ApplicationController
before_filter :signed_in_node

  def create
    @node = current_node
    @pulse = current_node.pulses.build(params[:pulse])
    @pulse.update_attributes(:reinforcements => 0, :degradations => 0,
                               :depth => 0)
    if @pulse.link
      @pulse.update_embed
    end
    if @pulse.save
      flash[:success] = 'Pulse Fired!'
          if @pulse.pulser_type == 'Node'
            @node.pulses << @pulse
              current_node.fire_pulse(:pulse => @pulse)
              redirect_to root_url(params[:node])
          else if @pulse.pulser_type == 'Assembly'
                   Assembly.find(session[:return_to]).pulses << @pulse
                   redirect_to Assembly.find(session[:return_to])
               end
          end

   else
      flash[:alert] = 'Content Cannot Be Blank!'
      if @pulse.pulser_type == 'Node'
        redirect_to root_url(params[:node])
      else
        redirect_to return_assembly
      end
   end
  end

  def show
    @pulse = Pulse.find(params[:id])
    store_location(params[:id])
    @pulse_comment = @pulse.pulse_comments.new
    @pulse_comments = @pulse.pulse_comments.paginate(:page => params[:page])
  end

  def destroy
    @pulse = Pulse.find(params[:id])
    @node = Node.find(@pulse.pulser)
    @pulse.destroy
    flash[:success] = "Pulse deleted."
    redirect_to Node.find(session[:return_to])
  end

  def cast
  @pulse = Pulse.find(params[:id])
  current_node.rate_pulse(:pulse => @pulse, :rating => params[:vote_cast])
  redirect_to Node.find(session[:return_to])
  end

end
