# Pure, deterministic API — no network calls

puts MitStalker.finger_timeout

puts MitStalker.flip_full_name("Costan, Victor-Marius")
puts MitStalker.flip_full_name("Smith, John")

puts MitStalker.name_vector("Victor Marius Costan").inspect
puts MitStalker.name_vector("Costan  Victor").inspect

response = "name: Victor Costan\r\nyear: 1\r\n\r\nname: Jane Doe\r\nyear: 2\r\n"
users = MitStalker.parse_mitdir_response(response)
users.each { |u| puts u.sort_by { |k, _| k.to_s }.map { |k, v| "#{k}=#{v}" }.join(" ") }

puts MitStalker.parse_mitdir_response(nil).inspect
puts MitStalker.parse_mitdir_response("").inspect
