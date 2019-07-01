# First we pull in the standard API hooks.
require 'sketchup.rb'
require 'pp'
require 'date'
# Show the Ruby Console at startup so we can
# see any programming errors we may make.
SKETCHUP_CONSOLE.show


# plugin scripts located in:
# /Users/username/Library/Application Support/SketchUp 2017/SketchUp/Plugins

# to reload this file / plugin while sketchup is open (for development)
# from console
# load 'plugin_reloader_menu.rb'

# from Extensions / Plugins menu
# Extensions > Plugin - RELOADER > Reload 'Plugin Reloader'


module SKPluginDev
  module PluginReloader
    # Module Variables:
    @@loaded ||= false
    
    # Run Once block:
    # Add a menu item for the extension reloader alow development w/o restarting sketchup.
    if not @@loaded
      plugins_menu = UI.menu("Plugins")
      
      submenu = plugins_menu.add_submenu("Plugin - RELOADER")
      
      # add development plugins here
      submenu.add_item("Reload 'Plugin Reloader'") { load 'plugin_reloader_menu.rb' }
      
      submenu.add_item("Reload 'Bevel Gear Maker'") { load 'bevel_gear_plugin.rb' }
      
      submenu.add_item("Reload 'Hello World'") { load 'plug_hello_world.rb' }
      
      puts "\n==> NAME: Plugin Reloader - Loaded - #{Time.now.strftime("%Y-%d-%m %H:%M:%S %Z")}"
      
      pp plugins_menu      
            
      @@loaded = true
    end
    # alternatively
    #unless file_loaded?(__FILE__)
    #  menu.add_item('Bevel Gear') {        
    #    self.create_bevel_gear
    #  }
    #
    #  file_loaded(__FILE__)
    #end

  end # module SKPluginDev
end # module PluginReloader

# visible from console on every re-load
puts "\n==> NAME: Plugin Reloader - Loaded - #{Time.now.strftime("%Y-%d-%m %H:%M:%S %Z")}"