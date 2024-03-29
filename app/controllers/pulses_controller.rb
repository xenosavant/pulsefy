class PulsesController < ApplicationController

before_filter :signed_in_node
include SessionsHelper
include ApplicationHelper

  def create
    @node = current_node
    @pulse = current_node.pulses.build(params[:pulse])
    @pulse.update_attributes(:reinforcements => 0, :degradations => 0,
                               :depth => 0, :refires => 0)
    if @pulse.save
      case @pulse.link.nil?
        when false
          update_embed(:pulse => @pulse)
      end
      #case @pulse.content.nil?
      #  when false
      #    update_content(:pulse => @pulse)
      #end
      case @pulse.pulser_type
           when 'Node'
            @node.pulses << @pulse
              Node.find(@pulse.pulser).fire_pulse(:pulse => @pulse)
              redirect_to root_url(params[:node])
            when 'Assembly'
              Assembly.find(session[:return_to]).pulses << @pulse
              redirect_to Assembly.find(session[:return_to])
      end
      else
        case @pulse.pulser_type
          when 'Node'
            redirect_to root_url(:errors => @pulse.errors.full_messages)
          when 'Assembly'
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
    case Pulse.find(params[:id]).nil?
      when false
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
  @image_regex = /^https?:\/\/(?:[a-z\-]+\.)+[a-z]{2,6}(?:\/[^\/#?]+)+\.(?:jpe?g|gif|png|svg)$/i
  api = Embedly::API.new
  @embed = api.oembed :url => @pulse.link, :key => '07cf494178ce4c2ba9c3ba65eb369f29'
  @pulse.update_attributes(:embed_code => @embed[0].html, :thumbnail => @embed[0].thumbnail_url,
                           :link_type => @embed[0].type, :url => @embed[0].url)
  case @pulse.link_type == 'photo' || @pulse.link_type == 'video'
    when false
      @valid_link =  @pulse.link.scan(@image_regex).first
      case  @valid_link.nil?
        when false
          @pulse.update_attributes(:link_type => 'photo', :url => @pulse.link, :url => @valid_link)
        when true
          @pulse.update_attributes(:link_type => 'link', :url => @pulse.link)
      end
  end
  @pulse.save
end

  #def update_content(args)
  #      @pulse = args[:pulse]
  #      @temp_text = simple_format(@pulse.content, :sanitize => false)
  #      #@image_regex = /^https?:\/\/(?:[a-z\-]+\.)+[a-z]{2,6}(?:\/[^\/#?]+)+\.(?:jpe?g|gif|png)$/i
  #      #@matches =  @temp_text.scan(@image_regex)
  #      #@matches.each do |url|
  #      #   @temp_text.sub! url, "<img src = '#{url}'>"
  #      #end
  #    @pulse.update_attributes(:content => @temp_text)
  #end
  #

end
