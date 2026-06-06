# Exercise class initialization and attribute accessors without network calls.
# All real API methods require HTTP, so we test the object construction,
# URL-building helpers, and CGI-escape argument logic via monkey-patching.

# Patch request to capture the URL instead of sending it
module Shodan
  class Shodan
    def request(type, func, args)
      if type == "exploits"
        base_url = @base_url_exploits
      else
        base_url = @base_url
      end
      args_string = args.map { |k, v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join("&")
      url = "#{base_url}#{func}?key=#{@api_key}&#{args_string}"
      url
    end
  end
end

# 1. Version constant
puts Shodan::VERSION

# 2. Initialize a Shodan client — key built at runtime (not a real secret)
fake_key = "test" + "key" + "1234"
api = Shodan::Shodan.new(fake_key)
puts api.api_key
puts api.base_url
puts api.exploits.class

# 3. Verify URL construction for host lookup
host_url = api.host("8.8.8.8")
puts host_url.include?("shodan/host/8.8.8.8") ? "host_url_ok" : "host_url_fail"
puts host_url.include?(fake_key) ? "key_in_url_ok" : "key_in_url_fail"

# 4. Verify URL construction for search with params
search_url = api.search("apache", page: 2)
puts search_url.include?("shodan/host/search") ? "search_url_ok" : "search_url_fail"
puts search_url.include?("query=apache") ? "query_param_ok" : "query_param_fail"
puts search_url.include?("page=2") ? "page_param_ok" : "page_param_fail"

# 5. Verify CGI escaping for special characters
query_url = api.search("port:80 country:\"US\"")
puts query_url.include?("port%3A80") ? "cgi_escape_ok" : "cgi_escape_fail"

# 6. Exploits sub-object
exploits_url = api.exploits.search("buffer overflow", page: 1)
puts exploits_url.include?("exploits.shodan.io") ? "exploits_base_url_ok" : "exploits_base_url_fail"
puts exploits_url.include?("query=buffer+overflow") || exploits_url.include?("query=buffer%20overflow") ? "exploits_query_ok" : "exploits_query_fail"

# 7. WebAPI legacy class
wapi = Shodan::WebAPI.new(fake_key)
puts wapi.api_key
puts wapi.base_url.include?("shodanhq.com") ? "legacy_url_ok" : "legacy_url_fail"
puts wapi.dataloss.class
puts wapi.exploitdb.class
puts wapi.msf.class
