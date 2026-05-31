q = SqlSpy::Query.new("User Load", "SELECT * FROM users", 1.5)
puts q.name
puts q.sql
puts q.duration
puts q.model_name

q2 = SqlSpy::Query.new("Post Create", "INSERT INTO posts VALUES (1)", 2.0)
puts q2.name
puts q2.model_name

t = SqlSpy::Tracker.new
puts t.queries.class
puts SqlSpy::Tracker::IGNORED_NAMES.inspect
