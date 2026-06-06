# frozen_string_literal: true

require 'minitel'

# --- StrictArgs: valid args pass ---
begin
  Minitel::StrictArgs.enforce(
    { app_uuid: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeee', title: 'Hello', body: 'World' },
    [:app_uuid, :title, :body],
    [],
    :app_uuid
  )
  puts "strict_args valid: ok"
rescue => e
  puts "strict_args valid: FAIL #{e}"
end

# --- StrictArgs: missing key raises ---
begin
  Minitel::StrictArgs.enforce(
    { title: 'Hello' },
    [:app_uuid, :title, :body],
    []
  )
  puts "strict_args missing: no error (bad)"
rescue ArgumentError => e
  puts "strict_args missing: #{e.message}"
end

# --- StrictArgs: extra key raises ---
begin
  Minitel::StrictArgs.enforce(
    { app_uuid: 'x', title: 'Hello', body: 'World', extra: 1 },
    [:app_uuid, :title, :body],
    []
  )
  puts "strict_args extra: no error (bad)"
rescue ArgumentError => e
  puts "strict_args extra: #{e.message}"
end

# --- StrictArgs: nil value raises ---
begin
  Minitel::StrictArgs.enforce(
    { app_uuid: nil, title: 'Hello', body: 'World' },
    [:app_uuid, :title, :body],
    [],
    :app_uuid
  )
  puts "strict_args nil: no error (bad)"
rescue ArgumentError => e
  puts "strict_args nil: #{e.message}"
end

# --- StrictArgs: bad UUID format raises ---
begin
  Minitel::StrictArgs.ensure_is_uuid('not-a-uuid')
  puts "uuid bad: no error (bad)"
rescue ArgumentError => e
  puts "uuid bad: #{e.message}"
end

# --- StrictArgs: valid UUID passes ---
begin
  Minitel::StrictArgs.ensure_is_uuid('aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeee')
  puts "uuid valid: ok"
rescue => e
  puts "uuid valid: FAIL #{e}"
end

# --- Error hierarchy ---
puts "HTTP::NotFound < HTTP::ClientError: #{Minitel::HTTP::NotFound < Minitel::HTTP::ClientError}"
puts "HTTP::TooManyRequests < HTTP::ClientError: #{Minitel::HTTP::TooManyRequests < Minitel::HTTP::ClientError}"
puts "HTTP::ServerError < HTTP::Error: #{Minitel::HTTP::ServerError < Minitel::HTTP::Error}"

# --- Client: bad URL raises ArgumentError ---
begin
  Minitel::Client.new('http://user:pass@example.com')
  puts "client bad url: no error (bad)"
rescue ArgumentError => e
  puts "client bad url: #{e.message}"
end

# --- Client: good URL parses user/password ---
begin
  c = Minitel::Client.new('https://myuser:mypassword@api.example.com')
  puts "client user: #{c.user}"
  puts "client password: #{c.password}"
rescue => e
  puts "client init: FAIL #{e}"
end

puts "version: #{Minitel::VERSION}"
