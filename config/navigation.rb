# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|

    primary.item :edit, 'Edit', edit_path, :if => Proc.new { edit_menu? }
    primary.item :inbox, 'Inbox', inbox_path, :if => Proc.new { inbox_menu? }
    primary.item :requests, 'Requests', request_path, :if => Proc.new { inbox_menu? }
    primary.item :crop, 'Crop', crop_path, :if => Proc.new { crop_menu? }
    primary.item :edit, 'Edit', reassemble_path, :if => Proc.new { assedit_menu? }
    primary.item :asscrop, 'Crop', asscrop_path, :if => Proc.new { asscrop_menu? }
    primary.item :account, 'Account', account_path, :if => Proc.new { edit_menu? }
    primary.item :myassemblies, 'My Assemblies', view_path, :if => Proc.new { assembly_menu? }
    primary.item :reassemble, 'Form An Assembly', assemble_path, :if => Proc.new { assembly_menu? }
    primary.item :showinputs, 'My Inputs', inputs_path, :if => Proc.new { connections_menu? }
    primary.item :showoutputs, 'My Outputs', outputs_path, :if => Proc.new { connections_menu? }
    primary.item :showotherinputs, 'Inputs', '#', :if => Proc.new { other_inputs_menu? }, :highlights_on => Proc.new { other_inputs_menu? }
    primary.item :showotheroutputs, 'Outputs', '#', :if => Proc.new { other_outputs_menu? }, :highlights_on => Proc.new { other_outputs_menu? }
    primary.item :home, 'Home', root_path, :if => Proc.new { home_menu? }, :highlights_on => Proc.new { home_menu? }

    end

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    #primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    #primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  end
