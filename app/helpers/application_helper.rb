module ApplicationHelper

  def edit_menu?
    case params[:controller]
      when 'nodes'
         if params[:action] == 'edit'
           true
         elsif params[:action] == 'account'
           true
         elsif params[:action] == 'crop'
           true
         else
           false
         end
      else
         false
    end
  end

  def assembly_menu?
    case params[:controller]
      when 'assemblies'
        if params[:action] == 'new'
          true
        elsif params[:action] == 'show_assemblies'
          true
        else
          false
        end
      else
        false
    end
  end

  def connections_menu?
    case params[:controller]
      when 'nodes'
        if params[:action] == 'show_inputs'
          true
        elsif params[:action] == 'show_outputs'
          true
        else
          false
        end
      else
        false
    end
  end

  def other_inputs_menu?
    case params[:controller]
      when 'nodes'
        if params[:action] == 'show_other_inputs'
          true
        else
          false
        end
      else
        false
    end
  end

  def other_outputs_menu?
    case params[:controller]
      when 'nodes'
        if params[:action] == 'show_other_outputs'
          true
        else
          false
        end
      else
        false
    end
  end

  def home_menu?
    case params[:controller]
      when 'nodes'
        if params[:action] == 'show'
          true
        elsif params[:action] == 'members'
          true
        else
          false
        end
      when 'assemblies'
        if params[:action] == 'show'
          true
        else
          false
        end
      when 'pulses'
        if params[:action] == 'show'
          true
        else
          false
        end
      when 'static'
        true
      else
        false
    end
  end

  def crop_menu?
    case params[:controller]
      when 'nodes'
        if params[:action] == 'crop'
          true
        else
          false
        end
    end
  end

  def assedit_menu?
    case params[:controller]
      when 'assemblies'
        if params[:action] == 'edit'
          true
        else
          false
        end
    end
  end

  def asscrop_menu?
    case params[:controller]
      when 'assemblies'
        if params[:action] == 'crop'
          true
        else
          false
        end
    end
  end


  def inbox_menu?
    case params[:controller]
      when 'inboxes'
         true
      when 'messages'
        true
      else
         false
    end
  end

  def parse_content(args)
    @object = args[:object]
    @content = @pulse.content
    @regex = /^https?:\/\/(?:[a-z\-]+\.)+[a-z]{2,6}(?:\/[^\/#?]+)+\.(?:jpe?g|gif|png)$/
    @url = @content.scan(@regex).first
    case @url.nil?
      when false
        @temp_string =  "<image alt = 'image' src = ''>"
        @pulse.content =  @temp_string
        @pulse.save
    end
  end

end

