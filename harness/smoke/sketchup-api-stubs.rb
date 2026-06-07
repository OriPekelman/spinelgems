require 'sketchup-api-stubs'

# sketchup-api-stubs: pure stubs gem for the SketchUp Ruby API.
# All method bodies are empty (return nil); the gem's value is the
# class/module/constant hierarchy it defines for IDE type-checking.
# We exercise: class existence, constant presence, method dispatch,
# and stub inheritance structure.

# --- Module & class hierarchy ---
puts Geom.class                        # Module
puts Geom::Point3d.class               # Class
puts Geom::Vector3d.class              # Class
puts Geom::Transformation.class        # Class
puts Geom::BoundingBox.class           # Class

puts Sketchup.class                    # Module
puts Sketchup::Color.class             # Class
puts Sketchup::Model.class             # Class

puts Length.class                      # Class
puts Length.superclass                 # Float

# --- Stub method dispatch (all return nil by design) ---
pt = Geom::Point3d.new(1, 2, 3)
puts pt.class                          # Geom::Point3d
puts pt.x.inspect                      # nil (stub)
puts pt.y.inspect                      # nil
puts pt.z.inspect                      # nil
puts pt.to_a.inspect                   # nil (stub)
puts pt.inspect.inspect                # nil or String
puts pt.distance(pt).inspect           # nil

v = Geom::Vector3d.new(0, 0, 1)
puts v.class                           # Geom::Vector3d
puts v.length.inspect                  # nil (stub)
puts v.valid?.inspect                  # nil (stub)
puts v.normalize.inspect               # nil (stub)
puts v.dot(v).inspect                  # nil (stub)

# linear_combination class method (stub)
puts Geom::Point3d.linear_combination(0.5, pt, 0.5, pt).inspect   # nil
puts Geom::Vector3d.linear_combination(0.5, v, 0.5, v).inspect    # nil

# --- Top-level constants (all nil stubs) ---
puts X_AXIS.inspect                    # nil
puts Y_AXIS.inspect                    # nil
puts Z_AXIS.inspect                    # nil
puts ORIGIN.inspect                    # nil
puts GL_TRIANGLES.inspect              # nil

# --- Numeric extension stubs ---
puts 12.to_l.inspect                   # nil (stub)
puts 1.inch.inspect                    # nil (stub)
puts 90.degrees.inspect                # nil (stub)

# --- String extension stub ---
puts "5'".to_l.inspect                 # nil (stub)

# --- respond_to? checks for key interface surface ---
puts pt.respond_to?(:offset)          # true
puts pt.respond_to?(:transform)       # true
puts pt.respond_to?(:vector_to)       # true
puts v.respond_to?(:cross)            # true
puts v.respond_to?(:angle_between)    # true

# --- Inheritance ---
puts Sketchup::ArcCurve.superclass     # Sketchup::Curve
puts Sketchup::ComponentInstance.superclass # Sketchup::Drawingelement

puts "ok"
