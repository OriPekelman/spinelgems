require "rubygems/package"; require "rubygems/specification"; require "timeout"
ARGV.each do |path|
  begin
    spec = Timeout.timeout(8) {
      path.end_with?(".gem") ? Gem::Package.new(path).spec : Gem::Specification.load(path)
    }
    next unless spec && spec.name && !spec.name.empty?
    deps = spec.runtime_dependencies.map(&:name)
    if deps.empty? then $stdout.puts "#{spec.name}\t"
    else deps.each { |d| $stdout.puts "#{spec.name}\t#{d}" } end
  rescue Exception
  end
end
