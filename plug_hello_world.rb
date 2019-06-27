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

draw_table_with_dimensions(0, 0, 0, 2000, 500, 100, 900, 70)

puts "\n==> NAME: Hellow World w Tables - Loaded"
puts "FROM: #{__FILE__}"
require 'FileUtils'
content = File.read(__FILE__)
puts "\nFunctions available:"
content.each_line{ |l| l =~ /^def (.*?)$/; puts $1 if $1 }

