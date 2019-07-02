# First we pull in the standard API hooks.
require 'sketchup.rb'

# this simple pluging allow reloading plugins/extensions w/o poluting the extensions menu :)
# add
# puts "\n==> NAME: Plugin name - Loaded - #{Time.now.strftime("%Y-%d-%m %H:%M:%S %Z")}"
# so fresh reload is obvios from console


# more on Sketchup API here
# http://ruby.sketchup.com/Sketchup.html

# adding tools
# http://ruby.sketchup.com/UI/Command.html
# http://ruby.sketchup.com/UI/Toolbar.html

# other refs
# plugin pattern/template
# from: https://forums.sketchup.com/t/change-a-menu-item/38590/10
#
# see also
# https://github.com/SketchUp/sketchup-ruby-api-tutorials   # alot of comments below from here


# Show the Ruby Console at startup so we can
# see any programming errors we may make.
SKETCHUP_CONSOLE.show


# this can be run directly from the console
# draw_bevel_gear_rings

def draw_bevel_gear_rings (list=[11, 20, 29, 38, 47, 56, 64, 73, 82, 91, 100, 109, 118, 127, 136, 145, 154, 162, 171, 180, 189, 198, 207, 216])
  puts 'Smelly poluting namespace function'
  puts __callee__
  puts __method__
end

puts "\n==> NAME: Bevel Gear maker - Loaded - #{Time.now.strftime("%Y-%d-%m %H:%M:%S %Z")}"


module SKTestRuns
  module BevelGear
    # Module Variables:
    @@loaded ||= false
    
    # Constants:
    MENUTEXT_LS ||= "Little Stick"
    MENUTEXT_BG ||= "Bevel Gear"
    

    # This method creates a simple pulled square inside of a group in the model.
    # 
    def self.little_stick
      # We need a reference to the currently active model. The SketchUp API
      # currently only lets you work on the active model. Under Windows there
      # will be only one model open at a time, but under OS X there might be
      # multiple models open.
      #
      # Beware that if there is no model open under OS X then `active_model`
      # will return nil. In this example we ignore that for simplicity.
      model = Sketchup.active_model

      # Whenever you make changes to the model you must take care to use
      # `model.start_operation` and `model.commit_operation` to wrap everything
      # into a single undo step. Otherwise the user risks not being able to
      # undo everything and she may loose work.
      #
      # Making sure your model changes are undoable in a single undo step is a
      # requirement of the Extension Warehouse submission quality checks.
      #
      # Note that the first argument name is a string that will be appended to
      # the Edit > Undo menu - so make sure you name your operations something
      # the users can understand.
      model.start_operation('Create Little Stick', true)

      # Creating a group via the API is slightly different from creating a
      # group via the UI.  Via the UI you create the faces first, then group
      # them. But with the API you create the group first and then add its
      # content directly to the group.
      group = model.active_entities.add_group
      entities = group.entities

      # Here we define a set of 3d points to create a 1x1m face. Note that the
      # internal unit in SketchUp is inches. This means that regardless of the
      # model unit settings the 3d data is always stored in inches.
      #
      # In order to make it easier work with lengths the Numeric class has
      # been extended with some utility methods that let us write stuff like
      # `1.m` to represent a meter instead of `39.37007874015748`.
      # 1.mm also works
      points = [
        Geom::Point3d.new(0,   0,   0),
        Geom::Point3d.new(1.mm, 0,   0),
        Geom::Point3d.new(1.mm, 1.mm, 0),
        Geom::Point3d.new(0,   1.mm, 0)
      ]

      # We pass the points to the `add_face` method and keep the returned
      # reference to the face as we want to keep working with it.
      #
      # Note that normally the orientation (its normal) is a result of the order
      # of the 3d points you use to create it. The exception is when you create
      # a face on the ground plane (all points with z == 0) then it will always
      # be face down.
      face = entities.add_face(points)

      # Here we invoke SketchUp's push-pull functionality on the face. But note
      # that we must use a negative number in order for it to extrude upwards
      # in the positive direction of the Z-axis. This is because SketchUp
      # forced this face on the ground place to be face down.
      face.pushpull(-10.mm)

      # Finally we are done and we close the operation. In production you will
      # want to catch errors and abort to clean up if your function failed.
      # But for simplicity we won't do this here.
      model.commit_operation
    end

    def self.create_concentric_rings
      # inner edge diameters
      inner_diameters = [11, 20, 29, 38, 47, 56, 64, 73, 82, 91, 100, 109, 118, 127, 136, 145, 154, 162, 171, 180, 189, 198, 207, 216]
    
      create_cog inner_diameters[0].mm
      
      inner_diameters.each{ |d|
        create_cog d  
      }
      
    end

    def self.create_cog(inner_d, width = 3.0, dbg_cylinder_radius = 6.0)
      create_circle(inner_d.mm)
      # create face
      # pull out 
      create_circle((inner_d + 3).mm)      
    end

    def self.create_circle(d)
      # http://ruby.sketchup.com/Sketchup/ArcCurve.html
      # Draw a circle on the ground plane around the origin.
      center_point = Geom::Point3d.new(0,0,0)
      normal_vector = Geom::Vector3d.new(0,0,1)
      radius = d/2
      
      entities = Sketchup.active_model.entities
      edgearray = entities.add_circle center_point, normal_vector, radius
      first_edge = edgearray[0]
      arccurve = first_edge.curve      
    end

    # Run Once block:
    # Add a menu item for the extension.
    if not @@loaded
      menu = UI.menu('Plugins')
      
      menu.add_item(MENUTEXT_LS) { self.little_stick }
      menu.add_item(MENUTEXT_BG) { self.create_concentric_rings }
      
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

  end # module BevelGear
end # module SKTestRuns



=begin
# manipulating menus seems oddly high friction!
# from: https://forums.sketchup.com/t/change-a-menu-item/38590/10
module TheWiz
  module SomePlugin

    # Constants:
    MENUTEXT ||= "Test"

    # Classes used only by this plugin here:
    class MyTestDialog
      def initialize(*args)
        # code that inits the new instance
        # (This method is called by ::new
        #   just after it creates the new instance.)
      end
      #
      # ... other method definitions ...
      #
     end

    # Module Variables:
    @@loaded ||= false
    @@myTest ||= nil

    # Make methods available to each other,
    # by extending this module with itself.
    extend self

    # Methods:
    def run_test
      @@myTest = MyTestDialog.new
      puts @@myTest
    rescue => except
      puts except.inspect
      puts except.backtrace
    end

    # Run Once block:
    if not @@loaded
      mnuMenu = UI.menu('Extensions')
      mnuItem = mnuMenu.add_item(MENUTEXT) { run_test() }
      @@loaded = true
    end

  end
end
=end