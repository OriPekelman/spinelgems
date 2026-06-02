puts Repost::VERSION
html = Repost::Senpai.perform(
  "https://example.com/submit",
  params: { "foo" => "bar", "baz" => "qux" },
  options: { form_id: "test-form", autosubmit: false }
)
puts html.include?('<form id="test-form"')
puts html.include?('action="https://example.com/submit"')
puts html.include?('name="foo" value="bar"')
puts html.include?('name="baz" value="qux"')
puts html.include?('</form>')
