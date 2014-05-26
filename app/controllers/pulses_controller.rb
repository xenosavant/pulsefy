class PulsesController < ApplicationController

before_filter :signed_in_node
include SessionsHelper
include ApplicationHelper
include PulsesHelper

  def create
    @node = current_node
    @pulse = current_node.pulses.build(params[:pulse])
    @pulse.update_attributes(:reinforcements => 0, :degradations => 0,
                               :depth => 0, :refires => 0)
    if @pulse.save
      case !@pulse.link.nil?
        when true
          update_embed(:pulse => @pulse)
      end
          if @pulse.pulser_type == 'Node'
            @node.pulses << @pulse
              Node.find(@pulse.pulser).fire_pulse(:pulse => @pulse)
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
    store_location(params[:id], 'Pulse')
    @pulse_comment = @pulse.pulse_comments.new
    @pulse_comments = @pulse.pulse_comments.paginate(:page => params[:page])
  end

  def destroy
    if !Pulse.find(params[:id]).nil?
    @pulse = Pulse.find(params[:id])
    @pulse.destroy
    end
    return_back_to
  end

  def cast
    @pulse = Pulse.find(params[:id])
    current_node.rate_pulse(:pulse => @pulse, :rating => params[:vote_cast])
    return_back_to
  end

  def refire
    @pulse = Pulse.find(params[:id])
    current_node.re_fire(:pulse => @pulse)
    return_back_to
  end

 def update_embed(args)
  @pulse = args[:pulse]
  @content = @pulse.link
  @regex = /^https?:\/\/(?:[a-z\-]+\.)+[a-z]{2,6}(?:\/[^\/#?]+)+\.(?:jpe?g|gif|png)$/
  @temp_url = @content.scan(@regex).first
  case @temp_url.nil?
    when false
      @object.update_attributes(:url => "<img alt = 'image' src = '#{@temp_url}'",
                                :link_type => 'photo')
    when true
      api = Embedly::API.new
      @embed = api.oembed :url => @pulse.link
      case @embed[0].error
        when false
          @pulse.update_attributes(:embed_code => @embed[0].html, :thumbnail => @embed[0].thumbnail_url,
                                   :link_type => @embed[0].type, :url => @embed[0].url)
      end
  end

 end


end
