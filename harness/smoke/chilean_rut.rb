# chilean_rut smoke — pure RUT validation and formatting
puts RUT.valid_dv('5')
puts RUT.valid_dv('k')
puts RUT.valid_dv('z')
puts RUT.get_dv('12345678')
puts RUT.format('123456785')
puts RUT.validate('12.345.678-5')
puts RUT.validate('12.345.678-0')
puts RUT.remove_format('12.345.678-5')
