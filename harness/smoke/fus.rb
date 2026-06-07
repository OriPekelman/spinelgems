require 'fus'
require 'tmpdir'

# Dir.exists? was removed in Ruby 3.2; patch it so Fus::Finder can initialize
unless Dir.respond_to?(:exists?)
  def Dir.exists?(path) = Dir.exist?(path)
end

# Create a temporary directory with some Swift files to analyze
Dir.mktmpdir('fus_smoke') do |dir|
  # Write a "used" class
  File.write(File.join(dir, 'FooViewController.swift'), <<~SWIFT)
    class FooViewController: UIViewController {
      func viewDidLoad() { super.viewDidLoad() }
    }
    class BarViewController: UIViewController {
      let foo = FooViewController()
    }
  SWIFT

  # Write a class that is NOT used anywhere
  File.write(File.join(dir, 'UnusedHelper.swift'), <<~SWIFT)
    class UnusedHelper: NSObject {
      func doSomething() { }
    }
  SWIFT

  # Write a spec class (should be excluded as a spec)
  File.write(File.join(dir, 'FooTests.swift'), <<~SWIFT)
    class FooTests: XCTestCase {
      func testSomething() { }
    }
  SWIFT

  finder = Fus::Finder.new(dir)

  all_names = finder.swift_classnames.sort
  puts "Swift classes: #{all_names.join(', ')}"

  unused = finder.unused_classnames.sort
  puts "Unused classes: #{unused.join(', ')}"

  puts "Has unused: #{unused.any?}"

  # Test SwiftClass directly
  sc = Fus::SwiftClass.new('MyAwesomeClass')
  puts "Name: #{sc.name}"
  puts "Is spec: #{sc.spec?}"
  puts "Matches path: #{sc.matches_classname?('/path/to/MyAwesomeClass.swift')}"
  puts "Used in xml: #{sc.used_in_xml?('<view customClass="MyAwesomeClass" />')}"
  puts "Used in objc: #{sc.used_in_obj_c?('MyAwesomeClass *foo = nil;')}"
  puts "Used in swift: #{sc.used_in_swift?('let x: MyAwesomeClass = ...')}"

  # Test a spec class
  spec_class = Fus::SwiftClass.new('LoginViewControllerSpec')
  puts "Spec class is spec: #{spec_class.spec?}"

  puts "Version: #{Fus::VERSION}"
end
