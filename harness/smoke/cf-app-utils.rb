require 'cf-app-utils'
require 'json'

# Build a fake VCAP_SERVICES payload — no network, no filesystem.
vcap = {
  "elephantsql" => [
    {
      "name"        => "my-db",
      "label"       => "elephantsql",
      "tags"        => ["postgresql", "relational"],
      "credentials" => { "uri" => "postgres://user:pass@host/db" }
    }
  ],
  "sendgrid" => [
    {
      "name"        => "my-mailer",
      "label"       => "sendgrid",
      "tags"        => ["smtp", "email"],
      "credentials" => { "hostname" => "smtp.sendgrid.net", "username" => "sg_user" }
    }
  ]
}

fake_env = { "VCAP_SERVICES" => JSON.generate(vcap) }

svc = CF::App::Service.new(fake_env)

# find_by_name
db = svc.find_by_name("my-db")
puts "find_by_name: #{db['label']}"

# find_by_tag
pg = svc.find_by_tag("postgresql")
puts "find_by_tag(postgresql): #{pg['name']}"

# find_all_by_tag
all_relational = svc.find_all_by_tag("relational")
puts "find_all_by_tag(relational) count: #{all_relational.size}"

# find_all_by_tags (all tags must match)
multi = svc.find_all_by_tags(["postgresql", "relational"])
puts "find_all_by_tags([postgresql,relational]) count: #{multi.size}"

# find_by_label (regex match)
by_label = svc.find_by_label("elephantsql")
puts "find_by_label(elephantsql): #{by_label['name']}"

# Credentials wrapper
creds = CF::App::Credentials.new(fake_env)
db_creds = creds.find_by_service_name("my-db")
puts "credentials uri: #{db_creds['uri']}"

tag_creds = creds.find_by_service_tag("smtp")
puts "credentials smtp hostname: #{tag_creds['hostname']}"

label_creds = creds.find_all_by_service_label("sendgrid")
puts "credentials by label count: #{label_creds.size}"

puts "done"
