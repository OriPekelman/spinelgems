# Tros is an Avro library; its full API depends on stdlib (json, set, bigdecimal, net/http)
# which Spinel cannot resolve. Only the error classes defined in tros.rb itself are safe.
err = Tros::AvroError.new("test error")
puts err.message
puts err.is_a?(StandardError)
puts err.is_a?(Tros::AvroError)

type_err = Tros::AvroTypeError.new(nil, nil, "custom type error msg")
puts type_err.message
puts type_err.is_a?(Tros::AvroError)

type_err2 = Tros::AvroTypeError.new("myschema", "mydatum")
puts type_err2.message
