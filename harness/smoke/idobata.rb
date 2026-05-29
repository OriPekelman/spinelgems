# smoke: idobata - test hook_url accessors and Message.label_writer pure logic
puts Idobata.hook_url.inspect

Idobata.hook_url = "https://idobata.io/hook/test"
puts Idobata.hook_url

# label_writer is pure - no network call
params = Idobata::Message.label_writer({ source: "hello", label: { text: "info", type: "success" } })
puts params[:format]
puts params[:source].strip
