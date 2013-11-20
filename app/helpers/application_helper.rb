module ApplicationHelper

  def edit_menu?
    case params[:controller]
      when 'nodes'
         if params[:action] == 'edit'
           true
         elsif params[:action] == 'picup'
           true
         elsif params[:action] == 'account'
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
        if params[:action] == 'show_inputs' && params[:id] == current_node.id
          true
        elsif params[:action] == 'show_outputs' && params[:id] == current_node.id
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
        elsif params[:action] == 'show_inputs' && params[:id] != current_node.id
            true
        elsif params[:action] == 'show_outputs' && params[:id] != current_node.id
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

end

