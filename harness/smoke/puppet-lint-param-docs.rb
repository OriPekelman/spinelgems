require 'puppet-lint'
require 'puppet-lint/plugins/check_parameter_documentation'

# puppet-lint-param-docs registers a :parameter_documentation check that
# detects missing, extra, or duplicate parameter documentation in Puppet
# class/defined-type manifests. Exercise via PuppetLint's public API.

DUMMY_PATH = 'test.pp'

def run_check(code)
  linter = PuppetLint.new
  linter.path = DUMMY_PATH
  linter.code = code
  linter.run
  linter.problems.select { |p| p[:check] == :parameter_documentation }
end

# Case 1: fully documented with strings (@param) style — zero warnings
problems1 = run_check(<<~'PP')
  # @param foo A description of foo
  # @param bar A description of bar
  class mymod::myclass (
    String $foo,
    Integer $bar,
  ) {
  }
PP
puts "case1_problems: #{problems1.size}"

# Case 2: one undocumented param — one missing-doc warning
problems2 = run_check(<<~'PP')
  # @param foo A description of foo
  class mymod::myclass2 (
    String $foo,
    Integer $bar,
  ) {
  }
PP
puts "case2_problems: #{problems2.size}"
puts "case2_msg: #{problems2.first[:message]}" if problems2.any?

# Case 3: doc for non-existent param + real param undocumented — two warnings
problems3 = run_check(<<~'PP')
  # @param ghost A ghost parameter that does not exist
  class mymod::myclass3 (
    String $real,
  ) {
  }
PP
puts "case3_problems: #{problems3.size}"
msgs3 = problems3.map { |p| p[:message] }.sort
msgs3.each { |m| puts "case3_msg: #{m}" }

# Case 4: kafo doc style ($param:: ...) — zero warnings
problems4 = run_check(<<~'PP')
  # $alpha:: The alpha parameter
  # $beta:: The beta parameter
  class mymod::myclass4 (
    String $alpha,
    Boolean $beta,
  ) {
  }
PP
puts "case4_problems: #{problems4.size}"

# Case 5: @api private class — undocumented params should be skipped
problems5 = run_check(<<~'PP')
  # @api private
  class mymod::myclass5 (
    String $secret,
  ) {
  }
PP
puts "case5_problems: #{problems5.size}"

puts "done"
