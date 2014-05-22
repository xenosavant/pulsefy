module PulsesHelper

  def parse_link(args)
    @object = args[:object]
    @content = @object.link
    @regex = /^https?:\/\/(?:[a-z\-]+\.)+[a-z]{2,6}(?:\/[^\/#?]+)+\.(?:jpe?g|gif|png)$/
    @temp_url = @content.scan(@regex).first
    case @temp_url.nil?
      when false
        @object.update_attributes(:link_type => 'photo', :url => @temp_url)
    end
  end

end
