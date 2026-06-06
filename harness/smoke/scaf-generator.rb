require 'scaf-generator'

# VERSION constant
puts Scaf::Generator::VERSION

# Load the self-contained Atributo class (fold generator's attribute model)
# It lives in lib/generators/fold/atributo.rb with no Rails dependency
require 'generators/fold/atributo'

# Parse attribute descriptors: name, type, options
a1 = Atributo.new('titulo:string:unique')
puts "#{a1.nombre}:#{a1.clase}:unique=#{a1.es?(:unique)}:index=#{a1.es?(:index)}"

# Integer with index option
a2 = Atributo.new('edad:integer:index')
puts "#{a2.nombre}:#{a2.clase}:index=#{a2.es?(:index)}:opciones=#{a2.opciones}"

# Boolean with default true value
a3 = Atributo.new('activo:boolean:true')
puts "#{a3.nombre}:#{a3.clase}:default=#{a3.default}"

# No type given => defaults to :string
a4 = Atributo.new('descripcion')
puts "#{a4.nombre}:#{a4.clase}:opts=#{a4.tiene_opciones?}"

# Float type, no options — ejemplo returns false for non-string/integer/boolean
a5 = Atributo.new('precio:float')
puts "#{a5.nombre}:#{a5.clase}:ejemplo=#{a5.ejemplo}"

# References type with polymorphic option
a6 = Atributo.new('usuario:references:polymorphic')
puts "#{a6.nombre}:#{a6.clase}:poly=#{a6.es?(:polymorphic)}"

# CLASES constant covers all expected DB column types
puts Atributo::CLASES.include?(:decimal)
puts Atributo::OPCIONES.sort.inspect
