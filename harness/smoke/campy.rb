require 'campy'

# Exercise Room initialization and attribute readers
room = Campy::Room.new(account: 'mycompany', room: 'Engineering', token: 'tok123', ssl: true)
puts room.account
puts room.room
puts room.ssl.inspect

# Room with ssl defaulting to true
room2 = Campy::Room.new(account: 'acme', room: 'General')
puts room2.account
puts room2.ssl.inspect

# Room with ssl: false
room3 = Campy::Room.new(account: 'beta', room: 'Dev', token: 'tok456', ssl: false)
puts room3.ssl.inspect

# Exercise pre-initialized room_id (bypasses network)
room4 = Campy::Room.new(account: 'x', room: 'y', room_id: 42, token: 'tok')
puts room4.room_id

# Error classes are accessible
puts Campy::Room::NotFound.ancestors.include?(RuntimeError)
puts Campy::Room::ConnectionError.ancestors.include?(RuntimeError)

# NotFound can be raised and caught
begin
  raise Campy::Room::NotFound, "Room name 'Missing' could not be found."
rescue Campy::Room::NotFound => e
  puts e.message
end

# ConnectionError can be raised and caught
begin
  raise Campy::Room::ConnectionError, "Errno::ECONNREFUSED: Connection refused"
rescue Campy::Room::ConnectionError => e
  puts e.message
end

# VERSION constant
puts Campy::VERSION
