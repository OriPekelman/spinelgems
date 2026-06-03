# jsmin-ffi smoke — NOT smokeable under Spinel
#
# jsmin-ffi loads a compiled native shared library (Jsmin.so) via FFI.
# The .so is not present in the gem cache (never compiled), and even if
# it were, Spinel ignores plain `require 'ffi'` (loadpath issue) so the
# FFI::Library mechanism is unavailable.
#
# This smoke exists as a record; it will fail at `require 'jsmin_ffi'`
# under both CRuby (missing Jsmin.so) and Spinel (missing ffi constant).

require 'jsmin_ffi'

js = "function hello( ) { var x = 1 + 1 ; return x ; }"
result = JsminFFI.minify!(js)
puts result.length
puts result
