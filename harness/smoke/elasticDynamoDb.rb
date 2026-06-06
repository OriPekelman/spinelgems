require 'elasticDynamoDb'
# Load ConfigParser which is in the same lib subtree
require 'elasticDynamoDb/configparser'

puts ElasticDynamoDb::VERSION

# ConfigParser parses INI-style dynamic-dynamodb config files.
# Exercise it with a real-looking (but credential-free) config.
config_content = <<~INI
  [global]
  region: us-east-1
  aws-access-key-id: TESTKEY
  aws-secret-access-key-id: TESTSECRET

  [table: ^my-table$]
  min-provisioned-reads: 10
  min-provisioned-writes: 5
  reads-upper-alarm-threshold: 90

  [gsi: ^my-index$ table: ^my-table$]
  min-provisioned-reads: 4
  min-provisioned-writes: 2
INI

require 'tempfile'
tf = Tempfile.new(['dynamo-conf', '.conf'])
tf.write(config_content)
tf.flush

parser = ConfigParser.new(tf.path)
config = parser.parse

puts config['global']['region']
puts config['global']['aws-access-key-id']

table_key = config.keys.find { |k| k =~ /table/ && !k.include?('gsi') }
puts table_key
puts config[table_key]['min-provisioned-reads']
puts config[table_key]['min-provisioned-writes']

# Simulate the scale-factor logic from Cli#scale
scale_factor = 2.0
reads  = config[table_key]['min-provisioned-reads'].to_i
writes = config[table_key]['min-provisioned-writes'].to_i
puts (reads  * scale_factor).ceil
puts (writes * scale_factor).ceil

tf.close
tf.unlink
