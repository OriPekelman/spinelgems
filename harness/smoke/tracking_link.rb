require 'tracking_link'

# --- detect service type ---

# UPS: starts with 1Z + 15 word chars + 1 check digit
ups_num = "1Z999AA10123456784"
ups_service = TrackingLink::Base.detect(ups_num)
puts ups_service.name

# FedEx: 12-digit number (11 digits + 1 check digit)
fedex_num = "123456789012"
fedex_service = TrackingLink::Base.detect(fedex_num)
puts fedex_service.name

# USPS: starts with 91 + 20 digits
usps_num = "9102901000462189604217"
usps_service = TrackingLink::Base.detect(usps_num)
puts usps_service.name

# Invalid tracking number => false
invalid = TrackingLink::Base.detect("NOTAVALIDNUMBER")
puts invalid.inspect

# --- instantiate and get link ---

ups_obj = TrackingLink::Services::UPS.new(ups_num)
puts ups_obj.link

fedex_obj = TrackingLink::Services::Fedex.new(fedex_num)
puts fedex_obj.link

usps_obj = TrackingLink::Services::USPS.new(usps_num)
puts usps_obj.link

# --- TrackingLink::Base.new dispatches to the right service ---
obj = TrackingLink::Base.new(ups_num)
puts obj.class.name
puts obj.tracking_number
