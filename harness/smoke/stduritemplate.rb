require 'uri'
puts StdUriTemplate.expand("Hello {name}!", {"name" => "World"})
puts StdUriTemplate.expand("{x,y}", {"x" => "1", "y" => "2"})
puts StdUriTemplate.expand("/users/{id}/posts", {"id" => "42"})
puts StdUriTemplate.expand("{+path}", {"path" => "foo/bar"})
puts StdUriTemplate.expand("{#fragment}", {"fragment" => "section1"})
puts StdUriTemplate.expand("/search{?q}", {"q" => "ruby"})
