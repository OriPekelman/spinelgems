# castanet smoke — Ragel-generated CAS XML parsers + QueryBuilding
require_relative '/home/oripekelman/.cache/spinel-compat/gems/castanet-1.0.1/lib/castanet/responses'
require_relative '/home/oripekelman/.cache/spinel-compat/gems/castanet-1.0.1/lib/castanet/responses/ticket_validate'
require_relative '/home/oripekelman/.cache/spinel-compat/gems/castanet-1.0.1/lib/castanet/responses/proxy'
require_relative '/home/oripekelman/.cache/spinel-compat/gems/castanet-1.0.1/lib/castanet/query_building'

# TicketValidate: success response
tv_success = '<cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas"><cas:authenticationSuccess><cas:user>jdoe</cas:user></cas:authenticationSuccess></cas:serviceResponse>'
tv = Castanet::Responses::TicketValidate.from_cas(tv_success)
puts tv.ok?
puts tv.username

# TicketValidate: failure response
tv_fail_xml = '<cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas"><cas:authenticationFailure code="INVALID_TICKET">Ticket not recognized</cas:authenticationFailure></cas:serviceResponse>'
tv2 = Castanet::Responses::TicketValidate.from_cas(tv_fail_xml)
puts tv2.ok?
puts tv2.failure_code

# Proxy: success response
proxy_success = '<cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas"><cas:proxySuccess><cas:proxyTicket>PT-12345</cas:proxyTicket></cas:proxySuccess></cas:serviceResponse>'
pr = Castanet::Responses::Proxy.from_cas(proxy_success)
puts pr.ok?
puts pr.ticket

# QueryBuilding
class QBTest
  include Castanet::QueryBuilding
  def run
    puts query(['ticket', 'ST-abc'], ['service', 'http://example.com'])
    puts query(['a', nil], ['b', 'val'])
  end
end
QBTest.new.run
