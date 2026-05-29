# smoke for slackened 0.0.5 — drives BlockKit block builders (pure data, no network)
divider = Slackened::BlockKit::Blocks.divider
puts divider.to_h.inspect

header = Slackened::BlockKit::Blocks.header("Hello World")
puts header.to_h[:type]
puts header.to_h[:text][:type]
puts header.to_h[:text][:text]

text = Slackened::BlockKit::Blocks.text("some *markdown*")
puts text.to_h[:type]
puts text.to_h[:text]

section = Slackened::BlockKit::Blocks.section("field one", "field two")
puts section.to_h[:type]
puts section.to_h[:fields].length
