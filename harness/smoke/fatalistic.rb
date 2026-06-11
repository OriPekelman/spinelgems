puts Fatalistic::VERSION
puts Fatalistic::Locker.class
puts Fatalistic::PostgresLocker.superclass.name
puts Fatalistic::MySQLLocker.superclass.name
locker = Fatalistic::Locker.new(nil)
puts locker.class.name
puts locker.respond_to?(:lock)
puts locker.respond_to?(:unlock)
