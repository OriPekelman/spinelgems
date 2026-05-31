puts ToDots.to_dots({a: {b: 1, c: 2}, d: 3}).inspect
puts ToDots.to_dots({x: [1, 2], y: "hello"}).inspect
puts ToDots.to_dots({foo: {bar: {baz: "deep"}}}).inspect
puts ToDots.to_dots({}).inspect
puts ToDots.to_dots({name: "world"}).inspect
