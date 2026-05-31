# smoke for harri — GHC unused-import error parser
puts Harri::Version::VERSION

# Empty log returns empty array
empty_result = Harri.parse_unused_import_errors_from_log("")
puts empty_result.class
puts empty_result.length

# Log with no unused-import errors returns empty array
unrelated_log = "src/Foo/Bar.hs:712:14: error:\n    Not in scope: type constructor or class 'Foo'\n"
unrelated_result = Harri.parse_unused_import_errors_from_log(unrelated_log)
puts unrelated_result.length

# Test collector directly - gather errors from a log with a redundant whole-module import
log = "src/Foo/Bar.hs:31:1: error: [-Wunused-imports, -Werror=unused-imports]\n    The import of 'Alpha.Beta.Status' is redundant\n      except perhaps to import instances from 'Alpha.Beta.Status'\n    To import instances alone, use: import Alpha.Beta.Status()\n   |\n31 | import Alpha.Beta.Status\n   | ^^^^^^^^^^^^^^^^^^^^^^^^\n"
errors = Harri::Collector.gather_unused_import_errors(log)
puts errors.length
puts errors.first.first.strip
