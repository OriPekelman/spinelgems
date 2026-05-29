include ClassNames

puts classnames("foo", "bar")
puts classnames("foo", nil, "bar")
puts classnames({ active: true, disabled: false })
puts classnames("btn", { primary: true, secondary: false })
puts classnames("a", "b", { c: true, d: false }, "e")
puts classnames()
