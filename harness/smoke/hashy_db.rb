# hashy_db smoke — exercises version constants, config, and in-memory data operations
puts Mince::HashyDb::Version.major
puts Mince::HashyDb::Version.minor
puts Mince::HashyDb::Version.patch
puts Mince::HashyDb.version
puts Mince::HashyDb::Config.primary_key.inspect

Mince::HashyDb::Interface.add(:fruits, { id: '1', name: 'apple', color: 'red' })
Mince::HashyDb::Interface.add(:fruits, { id: '2', name: 'banana', color: 'yellow' })
puts Mince::HashyDb::Interface.find_all(:fruits).size
rec = Mince::HashyDb::Interface.get_for_key_with_value(:fruits, :color, 'red')
puts rec[:name]
Mince::HashyDb::Interface.update_field_with_value(:fruits, '1', :name, 'cherry')
puts Mince::HashyDb::Interface.find(:fruits, '1')[:name]
