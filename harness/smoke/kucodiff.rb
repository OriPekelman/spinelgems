require 'kucodiff'
require 'tmpdir'

# Create temporary YAML files for testing Kucodiff
Dir.mktmpdir do |dir|
  base = File.join(dir, 'base.yml')
  other = File.join(dir, 'other.yml')

  # Two minimal Kubernetes deployment manifests with some differences
  File.write(base, <<~YAML)
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: myapp
    spec:
      template:
        spec:
          containers:
            - name: web
              image: myapp:1.0
              env:
                - name: PORT
                  value: "8080"
                - name: LOG_LEVEL
                  value: info
  YAML

  File.write(other, <<~YAML)
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: myapp
    spec:
      template:
        spec:
          containers:
            - name: web
              image: myapp:2.0
              env:
                - name: PORT
                  value: "8080"
                - name: LOG_LEVEL
                  value: debug
  YAML

  result = Kucodiff.diff([base, other])
  key = "#{base}-#{other}"

  puts "Diff keys: #{result.keys.length}"
  diffs = result[key]
  puts "Different fields: #{diffs.length}"
  puts "Has image diff: #{diffs.any? { |k| k.include?('image') }}"
  puts "Has log level diff: #{diffs.any? { |k| k.include?('LOG_LEVEL') }}"

  # Test with ignore pattern
  result2 = Kucodiff.diff([base, other], ignore: /image/)
  diffs2 = result2[key]
  puts "After ignoring image - different fields: #{diffs2.length}"
  puts "Image diff present: #{diffs2.any? { |k| k.include?('image') }}"

  # Test with expected (known acceptable diffs)
  result3 = Kucodiff.diff([base, other], expected: { key => diffs })
  puts "All diffs expected: #{result3.empty?}"
end
