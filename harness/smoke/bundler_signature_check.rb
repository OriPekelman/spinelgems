require 'bundler_signature_check'

# The gem is a CLI tool (bin/bundler_signature_check) that reads a
# Gemfile.lock and reports gem signing policies. The lib/ component
# only provides the BundlerSignatureCheck module with a VERSION constant;
# all real logic lives in the executable and depends on 'bundler' and
# 'rubygems/security' which are external to this gem's lib tree.

puts BundlerSignatureCheck::VERSION
puts BundlerSignatureCheck.class
puts BundlerSignatureCheck.respond_to?(:name)
puts BundlerSignatureCheck.name
