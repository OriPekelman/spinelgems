require 'foldscaf'
require 'generators/fold/atributo'

# Foldscaf is a Rails scaffold generator. The Atributo class is the core
# attribute-parser used to parse scaffold arguments like "name:string:unique".

puts Foldscaf::VERSION

# Test basic attribute parsing
a1 = Atributo.new('title:string')
puts a1.nombre
puts a1.clase.inspect
puts a1.es?(:unique)
puts a1.tiene_opciones?

# Test with options
a2 = Atributo.new('slug:string:unique:index')
puts a2.nombre
puts a2.clase.inspect
puts a2.es?(:unique)
puts a2.es?(:index)
puts a2.tiene_opciones?

# Test integer type and ejemplo
a3 = Atributo.new('age:integer')
puts a3.clase.inspect
# ejemplo for integer returns rand(50) — non-deterministic, just check it's an Integer
puts a3.ejemplo.is_a?(Integer)

# Test boolean default
a4 = Atributo.new('active:true')
puts a4.clase.inspect
puts a4.default.inspect

# Test references type
a5 = Atributo.new('user:references')
puts a5.clase.inspect
puts a5.es?(:polymorphic)

# Test polymorphic option
a6 = Atributo.new('taggable:references:polymorphic')
puts a6.clase.inspect
puts a6.es?(:polymorphic)

# Test no-type defaults to string
a7 = Atributo.new('name')
puts a7.clase.inspect

# CLASES constant
puts Atributo::CLASES.include?(:string)
puts Atributo::CLASES.include?(:boolean)
puts Atributo::OPCIONES.include?(:unique)
