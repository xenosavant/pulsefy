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
  @image_regex = /http:\/\/(www\.flickr\.com\/photos\/.*|flic\.kr\/.*|.*imgur\.com\/.*|instagr\.am\/p\/.*|instagram\.com\/p\/.*)/
  @video_regex = /((http:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|youtu\.be\/.*|.*\.youtube\.com\/user\/.*|.*\.youtube\.com\/.*#.*\/.*|m\.youtube\.com\/watch.*|m\.youtube\.com\/index.*|.*\.youtube\.com\/profile.*|.*\.youtube\.com\/view_play_list.*|.*\.youtube\.com\/playlist.*|www\.youtube\.com\/embed\/.*|collegehumor\.com\/video:.*|collegehumor\.com\/video\/.*|www\.collegehumor\.com\/video:.*|www\.collegehumor\.com\/video\/.*|vine\.co\/v\/.*|www\.vine\.co\/v\/.*|www\.vimeo\.com\/groups\/.*\/videos\/.*|www\.vimeo\.com\/.*|vimeo\.com\/groups\/.*\/videos\/.*|vimeo\.com\/.*|vimeo\.com\/m\/#\/.*|player\.vimeo\.com\/.*|www\.vevo\.com\/watch\/.*|www\.vevo\.com\/video\/.*))|(https:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|www\.youtube\.com\/embed\/.*|vine\.co\/v\/.*|www\.vine\.co\/v\/.*|www\.vimeo\.com\/.*|vimeo\.com\/.*|player\.vimeo\.com\/.*)))/

  case  @pulse.link.scan(@image_regex).first.nil?
    when false
      @pulse.update_attributes(:link_type => 'photo', :url => @pulse.link)
  end

  case  @pulse.link.scan(@video_regex).first.nil?
    when false
      @pulse.update_attributes(:link_type => 'video', :url => @pulse.link)
  end
    #case @pulse.link_type.nil?
    #  when true
    #   api = Embedly::API.new
    #   @embed = api.oembed :url => @pulse.link
    #    case @embed[0].error
    #     when false
    #       @pulse.update_attributes(:embed_code => @embed[0].html, :thumbnail => @embed[0].thumbnail_url,
    #                               :link_type => @embed[0].type, :url => @embed[0].url)
    #     end
    #end
  @pulse.save
 end


end
