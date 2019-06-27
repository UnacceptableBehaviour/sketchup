# First we pull in the standard API hooks.
require 'sketchup.rb'

# Show the Ruby Console at startup so we can
# see any programming errors we may make.
SKETCHUP_CONSOLE.show

# Add a menu item to launch our plugin.
UI.menu("Plugins").add_item("Draw stairs") {
  UI.messagebox("I'm about to draw stairs!")
  
  draw_stairs
}

# Add a menu item to launch our plugin.
UI.menu("Plugins").add_item("Draw table") {  
  draw_table
}

# Add a menu item to launch our plugin.
UI.menu("Plugins").add_item("Draw 3 tables") {
  
  tables_x = 3
  tables_y = 
  dir_x = 1
  dir_y = 0
  dir_z = 0
    
  place_at_x = 0
  place_at_y = 0
  place_at_z = 40

  space = 5
  
  # table top
  top_length = 100    # 150   # x axis
  top_width = 50      # 75    # y axis
  top_thickness = 2   # 2
  leg_thickness = 3   # 3
  leg_height = 40     # 100
    
  for table_no_x in 0..tables_x -1
    for table_no_y in 0..tables_y -1 
      draw_table_with_dimensions( place_at_x + ( (top_length + space) * table_no_x), place_at_y + ( (top_width + space) * table_no_y), place_at_z, top_length, top_width, top_thickness, leg_height, leg_thickness)
    end
  end  
}

# Add a menu item to launch our plugin.
UI.menu("Plugins").add_item("Draw x by y tables") {
  
  tables_x = 20
  tables_y = 20
  dir_x = 1
  dir_y = 0
  dir_z = 0
    
  place_at_x = 0
  place_at_y = 0
  place_at_z = 40

  space = 5
  
  # table top
  top_length = 100    # 150   # x axis
  top_width = 50      # 75    # y axis
  top_thickness = 2   # 2
  leg_thickness = 3   # 3
  leg_height = 40     # 100
    
  for table_no_x in 0..tables_x -1
    for table_no_y in 0..tables_y -1 
      draw_table_with_dimensions( place_at_x + ( (top_length + space) * table_no_x), place_at_y + ( (top_width + space) * table_no_y), place_at_z, top_length, top_width, top_thickness, leg_height, leg_thickness)
    end
  end  
}


def draw_stairs

  # Create some variables.
  stairs = 10
  rise = 8
  run = 12
  width = 100
  thickness = 3

  # Get handles to our model and the Entities collection it contains.
  model = Sketchup.active_model
  entities = model.entities

  # Loop across the same code several times
  for step in 1..stairs
    
    # Calculate our stair corners.
    x1 = 0
    x2 = width
    y1 = run * step
    y2 = run * (step + 1)
    z = rise * step
    
    # Create a series of "points", each a 3-item array containing x, y, and z.
    pt1 = [x1, y1, z]
    pt2 = [x2, y1, z]
    pt3 = [x2, y2, z]
    pt4 = [x1, y2, z]

    # Call methods on the Entities collection to draw stuff.
    new_face = entities.add_face pt1, pt2, pt3, pt4
    new_face.pushpull thickness
  end

end

                                                                     # x axis    y axis
def draw_table_with_dimensions(place_at_x, place_at_y, place_at_z, top_length, top_width, top_thickness, leg_height, leg_thickness)
  # Get handles to our model and the Entities collection it contains.
  model = Sketchup.active_model
  entities = model.entities

  
  x1 = place_at_x
  x2 = place_at_x + top_length
  y1 = place_at_y
  y2 = place_at_y + top_width
  z = place_at_z
      
  # Create a series of "points", each a 3-item array containing x, y, and z.
  pt1 = [x1, y1, z]
  pt2 = [x2, y1, z]
  pt3 = [x2, y2, z]
  pt4 = [x1, y2, z]
  
  new_face = entities.add_face pt1, pt2, pt3, pt4
  new_face.pushpull top_thickness
  
  pt1 = [x1, y1, z]
  pt2 = [x1 + leg_thickness, y1, z]
  pt3 = [x1 + leg_thickness, y1 + leg_thickness, z]
  pt4 = [x1, y1 + leg_thickness, z]

  leg_1 = entities.add_face pt1, pt2, pt3, pt4
  leg_1.pushpull leg_height

  pt1 = [x2, y1, z]
  pt2 = [x2, y1 + leg_thickness, z]
  pt3 = [x2 - leg_thickness, y1 + leg_thickness, z]
  pt4 = [x2 - leg_thickness, y1, z]

  leg_2 = entities.add_face pt1, pt2, pt3, pt4
  leg_2.pushpull leg_height


  pt1 = [x2, y2, z]
  pt2 = [x2 - leg_thickness, y2, z]
  pt3 = [x2 - leg_thickness, y2 - leg_thickness, z]
  pt4 = [x2, y2 - leg_thickness, z]

  leg_3 = entities.add_face pt1, pt2, pt3, pt4
  leg_3.pushpull leg_height
  
  pt1 = [x1, y2, z]
  pt2 = [x1, y2 - leg_thickness, z]
  pt3 = [x1 + leg_thickness, y2 - leg_thickness, z]
  pt4 = [x1 + leg_thickness, y2, z]

  leg_4 = entities.add_face pt1, pt2, pt3, pt4
  leg_4.pushpull leg_height

end

def draw_table
  
  place_at_x = 0
  place_at_y = 0
  place_at_z = 40
  
  # table top
  top_length = 100    # 150
  top_width = 50      # 75
  top_thickness = 2   # 2
  leg_thickness = 3   # 3
  leg_height = 40     # 100

  draw_table_with_dimensions(place_at_x, place_at_y, place_at_z, top_length, top_width, top_thickness, leg_height, leg_thickness)

end

puts "\n==> NAME: Hellow World w Tables - Loaded"
puts "FROM: #{__FILE__}"
require 'FileUtils'
content = File.read(__FILE__)
puts "\nFunctions available:"
content.each_line{ |l| l =~ /^def (.*?)$/; puts $1 if $1}

