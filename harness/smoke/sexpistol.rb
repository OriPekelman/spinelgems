# Smoke: sexpistol - S-expression serializer
puts Sexpistol.to_sexp([:foo, :bar, :baz])
puts Sexpistol.to_sexp([:add, 1, 2])
puts Sexpistol.to_sexp("hello")
puts Sexpistol.to_sexp(42)
puts Sexpistol.to_sexp([:nested, [:a, :b], [:c, :d]])
