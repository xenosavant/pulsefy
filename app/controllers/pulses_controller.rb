class PulsesController < ApplicationController
before_filter :signed_in_node

  def create
    @node = current_node
    @pulse = current_node.pulses.build(params[:pulse])
    @pulse.update_attributes(:reinforcements => 0, :degradations => 0,
                               :depth => 0)
    if !@pulse.link.nil?
      update_embed
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
      if @pulse.pulser_type == 'Node'
      redirect_to root_url(:errors => @pulse.errors.full_messages)
      else
      @assembly = Assembly.find(session[:return_to])
      redirect_to :controller => 'assemblies', :action => 'show',
                  :id => session[:return_to], :errors => @pulse.errors.full_messages
      end

   end
  end

  def show
    @pulse = Pulse.find(params[:id])
    @pulse_comment = @pulse.pulse_comments.new
    @pulse_comments = @pulse.pulse_comments.paginate(:page => params[:page])
  end

  def destroy
    @pulse = Pulse.find(params[:id])
    if @pulse.pulser_type == 'Node'
    @pulse.destroy
    flash[:success] = "Pulse deleted."
    redirect_to Node.find(session[:return_to])
    else
    @pulse.destroy
    flash[:success] = "Pulse deleted."
    redirect_to Assembly.find(session[:return_to])
    end
  end

  def cast
  @pulse = Pulse.find(params[:id])
  current_node.rate_pulse(:pulse => @pulse, :rating => params[:vote_cast])
  redirect_to Node.find(session[:return_to])
  end

def update_embed
  api = Embedly::API.new
  @embed = api.oembed :url =>@pulse.link
  if @embed[0].error
    if @pulse.pulser_type == 'Node'
    redirect_to current_node
    else
    redirect_to Assembly.find(session[:return_to])
    end
    else
    @pulse.update_attributes(:embed_code => @embed[0].html, :thumbnail => @embed[0].thumbnail_url,
                           :link_type => @embed[0].type, :url => @embed[0].url)
  end
end


end
