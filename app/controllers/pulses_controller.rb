class PulsesController < ApplicationController
before_filter :signed_in_node
@@default_strength = 0.5
  def create
    @pulse = current_node.pulses.build(params[:pulse])
    @pulse.pulser = current_node.id
    @pulse.update_attributes(:reinforcements => 0, :degradations => 0,
                             :depth => 0, :pulser_type => current_node.class.name)
    if @pulse.save
      current_node.pulses << @pulse
      current_node.fire_pulse(:pulse => @pulse)
      redirect_to root_url(params[:node => current_node])
    else
      @feed_items = []
      render 'static/home'
    end
  end


  def destroy
  end

  def rate_up
  end

  def rate_down
  end

  end
