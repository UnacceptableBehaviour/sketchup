# First we pull in the standard API hooks.
require 'sketchup.rb'
require 'pp'
# Show the Ruby Console at startup so we can
# see any programming errors we may make.
SKETCHUP_CONSOLE.show


# plugin scripts located in:
# /Users/username/Library/Application Support/SketchUp 2017/SketchUp/Plugins

# to reload this file / plugin while sketchup is open (for development)
# from console
# load 'plugin_reloader_menu.rb'

# from submenu
plugins_menu = UI.menu("Plugins")

# from menu / code - define menu item in a loader plugin
plugins_menu.add_item("Reload Plugin..") { puts "Plugin reloader - loaded" }

submenu = plugins_menu.add_submenu("SUBMENU")

submenu.add_item("Plugin Reloader") { load 'plugin_reloader_menu.rb' }

submenu.add_item("Bevel Gear Maker") { load 'bevel_gear_plugin.rb' }

submenu.add_item("Hello World") { load 'plug_hello_world.rb' }

puts "NAME: Plugin Reloader - Loaded"

pp plugins_menu