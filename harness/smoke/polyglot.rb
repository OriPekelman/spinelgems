# smoke: polyglot - NestedLoadError#reraise codegen bug
# The NestedLoadError stores a LoadError via @le and reraises it.
# Spinel emits `sp_raise(self->iv_le)` passing mrb_int to const char* — C error.
begin
  le = LoadError.new("test load error")
  nle = Polyglot::NestedLoadError.new(le)
  nle.reraise
rescue LoadError => e
  puts e.message
end
puts "done"
