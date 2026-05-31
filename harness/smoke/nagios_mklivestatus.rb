# Smoke: nagios_mklivestatus - exercises Filter::Attr, Query builder, and Comparator constants
# All pure string construction, no network or filesystem access.

# Comparator constants
puts Nagios::MkLiveStatus::QueryHelper::Comparator::EQUAL
puts Nagios::MkLiveStatus::QueryHelper::Comparator::NOT_EQUAL
puts Nagios::MkLiveStatus::QueryHelper::Comparator::GREATER

# Build a Filter::Attr and convert to string
f = Nagios::MkLiveStatus::Filter::Attr.new("host_name", "=", "myhost")
puts f.to_s

f2 = Nagios::MkLiveStatus::Filter::Attr.new("state", "!=", "0")
puts f2.to_s

# Build a Query and check to_socket output
q = Nagios::MkLiveStatus::Query.new("hosts")
q.addColumn("name")
q.addColumn("state")
q.addFilter(f)
puts q.to_s
