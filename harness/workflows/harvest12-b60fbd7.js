export const meta = {
  name: 'spinelgems-harvest12-b60fbd7',
  description: 'Harvest #12: behaviour smokes for 200 newly-clean popular gems @ b60fbd7 (post-636-commit wave); verify --full or attribute. Filing OK (upstream active) but bank, do not file inline.',
  phases: [{ title: 'Smoke', detail: 'one agent per gem: read source, write smoke, verify, classify' }],
}

const GEMS =
[
  {
    "g": "aws-sdk-kms",
    "v": "1.128.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-kms-1.128.0"
  },
  {
    "g": "rspec",
    "v": "3.13.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rspec-3.13.2"
  },
  {
    "g": "jwt",
    "v": "3.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/jwt-3.2.0"
  },
  {
    "g": "rails-dom-testing",
    "v": "2.3.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rails-dom-testing-2.3.0"
  },
  {
    "g": "globalid",
    "v": "1.3.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/globalid-1.3.0"
  },
  {
    "g": "mini_portile2",
    "v": "2.8.9",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/mini_portile2-2.8.9"
  },
  {
    "g": "googleauth",
    "v": "1.17.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/googleauth-1.17.0"
  },
  {
    "g": "aws-sdk",
    "v": "3.3.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-3.3.0"
  },
  {
    "g": "aws-sdk-resources",
    "v": "3.264.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-resources-3.264.0"
  },
  {
    "g": "request_store",
    "v": "1.7.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/request_store-1.7.0"
  },
  {
    "g": "aws-sdk-sqs",
    "v": "1.115.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-sqs-1.115.0"
  },
  {
    "g": "jquery-rails",
    "v": "4.6.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/jquery-rails-4.6.1"
  },
  {
    "g": "uglifier",
    "v": "4.2.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/uglifier-4.2.1"
  },
  {
    "g": "sass-rails",
    "v": "6.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/sass-rails-6.0.0"
  },
  {
    "g": "factory_bot_rails",
    "v": "6.5.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/factory_bot_rails-6.5.1"
  },
  {
    "g": "aws-sdk-ssm",
    "v": "1.215.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-ssm-1.215.0"
  },
  {
    "g": "kaminari",
    "v": "1.2.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/kaminari-1.2.2"
  },
  {
    "g": "coffee-script",
    "v": "2.4.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/coffee-script-2.4.1"
  },
  {
    "g": "aws-sdk-ec2",
    "v": "1.620.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-ec2-1.620.0"
  },
  {
    "g": "simplecov_json_formatter",
    "v": "0.1.4",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/simplecov_json_formatter-0.1.4"
  },
  {
    "g": "coffee-rails",
    "v": "5.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/coffee-rails-5.0.0"
  },
  {
    "g": "aws-sdk-kinesis",
    "v": "1.101.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-kinesis-1.101.0"
  },
  {
    "g": "database_cleaner",
    "v": "2.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/database_cleaner-2.1.0"
  },
  {
    "g": "plist",
    "v": "3.7.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/plist-3.7.2"
  },
  {
    "g": "dotenv-rails",
    "v": "3.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/dotenv-rails-3.2.0"
  },
  {
    "g": "google-apis-storage_v1",
    "v": "0.63.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/google-apis-storage_v1-0.63.0"
  },
  {
    "g": "google-apis-iamcredentials_v1",
    "v": "0.27.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/google-apis-iamcredentials_v1-0.27.0"
  },
  {
    "g": "ipaddress",
    "v": "0.8.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ipaddress-0.8.3"
  },
  {
    "g": "xml-simple",
    "v": "1.1.9",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/xml-simple-1.1.9"
  },
  {
    "g": "css_parser",
    "v": "2.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/css_parser-2.2.0"
  },
  {
    "g": "aws-sdk-sns",
    "v": "1.116.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-sns-1.116.0"
  },
  {
    "g": "aws-sdk-cloudformation",
    "v": "1.153.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloudformation-1.153.0"
  },
  {
    "g": "aws-sdk-lambda",
    "v": "1.181.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-lambda-1.181.0"
  },
  {
    "g": "aws-sdk-secretsmanager",
    "v": "1.132.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-secretsmanager-1.132.0"
  },
  {
    "g": "aws-sdk-cloudwatch",
    "v": "1.138.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloudwatch-1.138.0"
  },
  {
    "g": "faraday-cookie_jar",
    "v": "0.0.8",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/faraday-cookie_jar-0.0.8"
  },
  {
    "g": "aws-sdk-iam",
    "v": "1.146.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-iam-1.146.0"
  },
  {
    "g": "gh_inspector",
    "v": "1.1.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/gh_inspector-1.1.3"
  },
  {
    "g": "aws-sdk-ecr",
    "v": "1.129.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-ecr-1.129.0"
  },
  {
    "g": "google-apis-androidpublisher_v3",
    "v": "0.102.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/google-apis-androidpublisher_v3-0.102.0"
  },
  {
    "g": "descendants_tracker",
    "v": "0.0.4",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/descendants_tracker-0.0.4"
  },
  {
    "g": "aws-sdk-cloudwatchlogs",
    "v": "1.153.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloudwatchlogs-1.153.0"
  },
  {
    "g": "climate_control",
    "v": "1.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/climate_control-1.2.0"
  },
  {
    "g": "faraday-http-cache",
    "v": "2.7.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/faraday-http-cache-2.7.0"
  },
  {
    "g": "redis-store",
    "v": "1.11.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/redis-store-1.11.0"
  },
  {
    "g": "aws-sdk-route53",
    "v": "1.135.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-route53-1.135.0"
  },
  {
    "g": "aws-sdk-ses",
    "v": "1.100.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-ses-1.100.0"
  },
  {
    "g": "aws-sdk-firehose",
    "v": "1.109.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-firehose-1.109.0"
  },
  {
    "g": "redis-actionpack",
    "v": "5.5.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/redis-actionpack-5.5.0"
  },
  {
    "g": "database_cleaner-active_record",
    "v": "2.2.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/database_cleaner-active_record-2.2.2"
  },
  {
    "g": "gyoku",
    "v": "1.4.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/gyoku-1.4.0"
  },
  {
    "g": "premailer",
    "v": "1.29.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/premailer-1.29.0"
  },
  {
    "g": "aws-sdk-elasticloadbalancing",
    "v": "1.90.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-elasticloadbalancing-1.90.0"
  },
  {
    "g": "rqrcode",
    "v": "3.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rqrcode-3.2.0"
  },
  {
    "g": "aws-sdk-rds",
    "v": "1.314.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-rds-1.314.0"
  },
  {
    "g": "omniauth-google-oauth2",
    "v": "1.2.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/omniauth-google-oauth2-1.2.2"
  },
  {
    "g": "xcpretty-travis-formatter",
    "v": "1.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/xcpretty-travis-formatter-1.0.1"
  },
  {
    "g": "deep_merge",
    "v": "1.2.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/deep_merge-1.2.2"
  },
  {
    "g": "aws-sdk-cloudfront",
    "v": "1.149.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloudfront-1.149.0"
  },
  {
    "g": "ruby-rc4",
    "v": "0.1.5",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/ruby-rc4-0.1.5"
  },
  {
    "g": "rubygems-bundler",
    "v": "1.4.5",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rubygems-bundler-1.4.5"
  },
  {
    "g": "word_wrap",
    "v": "1.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/word_wrap-1.0.0"
  },
  {
    "g": "aws-sdk-states",
    "v": "1.108.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-states-1.108.0"
  },
  {
    "g": "dogapi",
    "v": "1.45.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/dogapi-1.45.0"
  },
  {
    "g": "aws-sdk-codecommit",
    "v": "1.100.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-codecommit-1.100.0"
  },
  {
    "g": "aws-sdk-cloudwatchevents",
    "v": "1.106.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloudwatchevents-1.106.0"
  },
  {
    "g": "aws-sdk-ecs",
    "v": "1.234.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-ecs-1.234.0"
  },
  {
    "g": "aws-sdk-autoscaling",
    "v": "1.160.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-autoscaling-1.160.0"
  },
  {
    "g": "google-apis-playcustomapp_v1",
    "v": "0.17.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/google-apis-playcustomapp_v1-0.17.0"
  },
  {
    "g": "powerpack",
    "v": "0.1.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/powerpack-0.1.3"
  },
  {
    "g": "lint_roller",
    "v": "1.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/lint_roller-1.1.0"
  },
  {
    "g": "aws-sdk-elasticloadbalancingv2",
    "v": "1.152.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-elasticloadbalancingv2-1.152.0"
  },
  {
    "g": "rails-deprecated_sanitizer",
    "v": "1.0.4",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rails-deprecated_sanitizer-1.0.4"
  },
  {
    "g": "wasabi",
    "v": "5.1.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/wasabi-5.1.0"
  },
  {
    "g": "reverse_markdown",
    "v": "3.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/reverse_markdown-3.0.2"
  },
  {
    "g": "aws-sdk-cognitoidentityprovider",
    "v": "1.143.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cognitoidentityprovider-1.143.0"
  },
  {
    "g": "akami",
    "v": "1.3.3",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/akami-1.3.3"
  },
  {
    "g": "aws-sdk-athena",
    "v": "1.121.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-athena-1.121.0"
  },
  {
    "g": "aws-sdk-rekognition",
    "v": "1.132.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-rekognition-1.132.0"
  },
  {
    "g": "aws-sdk-configservice",
    "v": "1.151.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-configservice-1.151.0"
  },
  {
    "g": "aws-sdk-redshift",
    "v": "1.160.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-redshift-1.160.0"
  },
  {
    "g": "aws-sdk-apigateway",
    "v": "1.136.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-apigateway-1.136.0"
  },
  {
    "g": "rubocop-capybara",
    "v": "2.23.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rubocop-capybara-2.23.0"
  },
  {
    "g": "aws-sdk-elasticache",
    "v": "1.144.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-elasticache-1.144.0"
  },
  {
    "g": "aws-sdk-glue",
    "v": "1.259.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-glue-1.259.0"
  },
  {
    "g": "aws-sdk-elasticsearchservice",
    "v": "1.121.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-elasticsearchservice-1.121.0"
  },
  {
    "g": "redis-activesupport",
    "v": "5.3.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/redis-activesupport-5.3.0"
  },
  {
    "g": "aws-sdk-cloudtrail",
    "v": "1.123.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloudtrail-1.123.0"
  },
  {
    "g": "aws-sdk-pinpoint",
    "v": "1.123.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-pinpoint-1.123.0"
  },
  {
    "g": "aws-sdk-batch",
    "v": "1.145.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-batch-1.145.0"
  },
  {
    "g": "aws-sdk-organizations",
    "v": "1.142.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-organizations-1.142.0"
  },
  {
    "g": "aws-sdk-acm",
    "v": "1.105.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-acm-1.105.0"
  },
  {
    "g": "aws-sdk-mediaconvert",
    "v": "1.186.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-mediaconvert-1.186.0"
  },
  {
    "g": "aws-sdk-emr",
    "v": "1.131.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-emr-1.131.0"
  },
  {
    "g": "aws-sdk-codedeploy",
    "v": "1.100.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-codedeploy-1.100.0"
  },
  {
    "g": "aws-sdk-xray",
    "v": "1.100.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-xray-1.100.0"
  },
  {
    "g": "aws-sdk-databasemigrationservice",
    "v": "1.146.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-databasemigrationservice-1.146.0"
  },
  {
    "g": "aws-sdk-efs",
    "v": "1.111.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-efs-1.111.0"
  },
  {
    "g": "aws-sdk-sagemaker",
    "v": "1.369.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-sagemaker-1.369.0"
  },
  {
    "g": "aws-sdk-applicationautoscaling",
    "v": "1.122.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-applicationautoscaling-1.122.0"
  },
  {
    "g": "sixarm_ruby_unaccent",
    "v": "1.2.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/sixarm_ruby_unaccent-1.2.2"
  },
  {
    "g": "aws-sdk-codebuild",
    "v": "1.174.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-codebuild-1.174.0"
  },
  {
    "g": "aws-sdk-elasticbeanstalk",
    "v": "1.104.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-elasticbeanstalk-1.104.0"
  },
  {
    "g": "case_transform",
    "v": "0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/case_transform-0.2"
  },
  {
    "g": "aws-sdk-iot",
    "v": "1.168.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-iot-1.168.0"
  },
  {
    "g": "aws-sdk-cloudhsmv2",
    "v": "1.92.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloudhsmv2-1.92.0"
  },
  {
    "g": "aws-sdk-servicecatalog",
    "v": "1.130.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-servicecatalog-1.130.0"
  },
  {
    "g": "aws-sdk-codepipeline",
    "v": "1.116.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-codepipeline-1.116.0"
  },
  {
    "g": "aws-sdk-polly",
    "v": "1.125.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-polly-1.125.0"
  },
  {
    "g": "aws-sdk-lightsail",
    "v": "1.131.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-lightsail-1.131.0"
  },
  {
    "g": "aws-sdk-cognitoidentity",
    "v": "1.89.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cognitoidentity-1.89.0"
  },
  {
    "g": "aws-sdk-workspaces",
    "v": "1.159.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-workspaces-1.159.0"
  },
  {
    "g": "aws-sdk-budgets",
    "v": "1.109.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-budgets-1.109.0"
  },
  {
    "g": "aws-sdk-route53domains",
    "v": "1.96.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-route53domains-1.96.0"
  },
  {
    "g": "aws-sdk-waf",
    "v": "1.94.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-waf-1.94.0"
  },
  {
    "g": "jquery-ui-rails",
    "v": "8.0.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/jquery-ui-rails-8.0.0"
  },
  {
    "g": "aws-sdk-costandusagereportservice",
    "v": "1.89.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-costandusagereportservice-1.89.0"
  },
  {
    "g": "aws-sdk-shield",
    "v": "1.97.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-shield-1.97.0"
  },
  {
    "g": "aws-sdk-applicationdiscoveryservice",
    "v": "1.102.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-applicationdiscoveryservice-1.102.0"
  },
  {
    "g": "aws-sdk-cloudhsm",
    "v": "1.86.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloudhsm-1.86.0"
  },
  {
    "g": "aws-sdk-guardduty",
    "v": "1.152.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-guardduty-1.152.0"
  },
  {
    "g": "aws-sdk-directconnect",
    "v": "1.109.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-directconnect-1.109.0"
  },
  {
    "g": "aws-sdk-directoryservice",
    "v": "1.104.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-directoryservice-1.104.0"
  },
  {
    "g": "aws-sdk-gamelift",
    "v": "1.129.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-gamelift-1.129.0"
  },
  {
    "g": "aws-sdk-comprehend",
    "v": "1.116.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-comprehend-1.116.0"
  },
  {
    "g": "aws-sdk-storagegateway",
    "v": "1.127.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-storagegateway-1.127.0"
  },
  {
    "g": "aws-sdk-opsworks",
    "v": "1.79.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-opsworks-1.79.0"
  },
  {
    "g": "aws-sdk-appstream",
    "v": "1.136.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-appstream-1.136.0"
  },
  {
    "g": "aws-sdk-sms",
    "v": "1.77.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-sms-1.77.0"
  },
  {
    "g": "aws-sdk-devicefarm",
    "v": "1.106.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-devicefarm-1.106.0"
  },
  {
    "g": "aws-sdk-cloudsearch",
    "v": "1.89.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloudsearch-1.89.0"
  },
  {
    "g": "aws-sdk-resourcegroupstaggingapi",
    "v": "1.97.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-resourcegroupstaggingapi-1.97.0"
  },
  {
    "g": "prettyprint",
    "v": "0.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/prettyprint-0.2.0"
  },
  {
    "g": "aws-sdk-costexplorer",
    "v": "1.151.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-costexplorer-1.151.0"
  },
  {
    "g": "aws-sdk-medialive",
    "v": "1.188.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-medialive-1.188.0"
  },
  {
    "g": "aws-sdk-sagemakerruntime",
    "v": "1.98.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-sagemakerruntime-1.98.0"
  },
  {
    "g": "aws-sdk-lex",
    "v": "1.94.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-lex-1.94.0"
  },
  {
    "g": "aws-sdk-dax",
    "v": "1.87.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-dax-1.87.0"
  },
  {
    "g": "aws-sdk-glacier",
    "v": "1.94.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-glacier-1.94.0"
  },
  {
    "g": "aws-sdk-greengrass",
    "v": "1.96.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-greengrass-1.96.0"
  },
  {
    "g": "aws-sdk-health",
    "v": "1.100.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-health-1.100.0"
  },
  {
    "g": "aws-sdk-marketplacemetering",
    "v": "1.97.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-marketplacemetering-1.97.0"
  },
  {
    "g": "aws-sdk-simpledb",
    "v": "1.78.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-simpledb-1.78.0"
  },
  {
    "g": "aws-sdk-lexmodelbuildingservice",
    "v": "1.106.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-lexmodelbuildingservice-1.106.0"
  },
  {
    "g": "aws-sdk-elastictranscoder",
    "v": "1.80.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-elastictranscoder-1.80.0"
  },
  {
    "g": "aws-sdk-snowball",
    "v": "1.103.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-snowball-1.103.0"
  },
  {
    "g": "aws-sdk-iotdataplane",
    "v": "1.91.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-iotdataplane-1.91.0"
  },
  {
    "g": "aws-sdk-transcribeservice",
    "v": "1.140.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-transcribeservice-1.140.0"
  },
  {
    "g": "aws-sdk-migrationhub",
    "v": "1.88.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-migrationhub-1.88.0"
  },
  {
    "g": "aws-sdk-swf",
    "v": "1.87.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-swf-1.87.0"
  },
  {
    "g": "aws-sdk-machinelearning",
    "v": "1.87.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-machinelearning-1.87.0"
  },
  {
    "g": "aws-sdk-cloudsearchdomain",
    "v": "1.72.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloudsearchdomain-1.72.0"
  },
  {
    "g": "aws-sdk-marketplacecommerceanalytics",
    "v": "1.89.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-marketplacecommerceanalytics-1.89.0"
  },
  {
    "g": "aws-sdk-wafregional",
    "v": "1.95.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-wafregional-1.95.0"
  },
  {
    "g": "aws-sdk-inspector",
    "v": "1.91.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-inspector-1.91.0"
  },
  {
    "g": "aws-sdk-support",
    "v": "1.92.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-support-1.92.0"
  },
  {
    "g": "aws-sdk-workdocs",
    "v": "1.90.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-workdocs-1.90.0"
  },
  {
    "g": "aws-sdk-mturk",
    "v": "1.87.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-mturk-1.87.0"
  },
  {
    "g": "aws-sdk-clouddirectory",
    "v": "1.90.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-clouddirectory-1.90.0"
  },
  {
    "g": "aws-sdk-translate",
    "v": "1.98.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-translate-1.98.0"
  },
  {
    "g": "aws-sdk-marketplaceentitlementservice",
    "v": "1.88.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-marketplaceentitlementservice-1.88.0"
  },
  {
    "g": "aws-sdk-kinesisanalytics",
    "v": "1.87.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-kinesisanalytics-1.87.0"
  },
  {
    "g": "aws-sdk-datapipeline",
    "v": "1.83.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-datapipeline-1.83.0"
  },
  {
    "g": "aws-sdk-eks",
    "v": "1.167.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-eks-1.167.0"
  },
  {
    "g": "aws-sdk-cognitosync",
    "v": "1.83.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cognitosync-1.83.0"
  },
  {
    "g": "aws-sdk-opsworkscm",
    "v": "1.89.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-opsworkscm-1.89.0"
  },
  {
    "g": "redis-rails",
    "v": "5.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/redis-rails-5.0.2"
  },
  {
    "g": "aws-sdk-appsync",
    "v": "1.123.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-appsync-1.123.0"
  },
  {
    "g": "aws-sdk-importexport",
    "v": "1.73.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-importexport-1.73.0"
  },
  {
    "g": "aws-sdk-connect",
    "v": "1.258.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-connect-1.258.0"
  },
  {
    "g": "aws-sdk-mq",
    "v": "1.96.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-mq-1.96.0"
  },
  {
    "g": "aws-sdk-mediapackage",
    "v": "1.104.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-mediapackage-1.104.0"
  },
  {
    "g": "webdrivers",
    "v": "5.3.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/webdrivers-5.3.1"
  },
  {
    "g": "aws-sdk-kinesisvideo",
    "v": "1.95.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-kinesisvideo-1.95.0"
  },
  {
    "g": "aws-sdk-servicediscovery",
    "v": "1.102.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-servicediscovery-1.102.0"
  },
  {
    "g": "aws-sdk-pricing",
    "v": "1.94.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-pricing-1.94.0"
  },
  {
    "g": "aws-sdk-resourcegroups",
    "v": "1.98.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-resourcegroups-1.98.0"
  },
  {
    "g": "aws-sdk-workmail",
    "v": "1.100.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-workmail-1.100.0"
  },
  {
    "g": "aws-sdk-mediastore",
    "v": "1.88.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-mediastore-1.88.0"
  },
  {
    "g": "aws-sdk-kinesisvideoarchivedmedia",
    "v": "1.91.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-kinesisvideoarchivedmedia-1.91.0"
  },
  {
    "g": "aws-sdk-serverlessapplicationrepository",
    "v": "1.92.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-serverlessapplicationrepository-1.92.0"
  },
  {
    "g": "aws-sdk-cloud9",
    "v": "1.103.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-cloud9-1.103.0"
  },
  {
    "g": "aws-sdk-acmpca",
    "v": "1.111.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-acmpca-1.111.0"
  },
  {
    "g": "aws-sdk-mediastoredata",
    "v": "1.84.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-mediastoredata-1.84.0"
  },
  {
    "g": "aws-sdk-iotjobsdataplane",
    "v": "1.82.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-iotjobsdataplane-1.82.0"
  },
  {
    "g": "aws-sdk-kinesisvideomedia",
    "v": "1.83.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-kinesisvideomedia-1.83.0"
  },
  {
    "g": "aws-sdk-autoscalingplans",
    "v": "1.87.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-autoscalingplans-1.87.0"
  },
  {
    "g": "libv8",
    "v": "8.4.255.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/libv8-8.4.255.0.1"
  },
  {
    "g": "attr_required",
    "v": "1.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/attr_required-1.0.2"
  },
  {
    "g": "aws-sdk-fms",
    "v": "1.108.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-fms-1.108.0"
  },
  {
    "g": "aws-sdk-neptune",
    "v": "1.105.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-neptune-1.105.0"
  },
  {
    "g": "aws-sdk-mediatailor",
    "v": "1.121.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-mediatailor-1.121.0"
  },
  {
    "g": "aws-sdk-iotanalytics",
    "v": "1.93.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-iotanalytics-1.93.0"
  },
  {
    "g": "aws-sdk-pi",
    "v": "1.96.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-pi-1.96.0"
  },
  {
    "g": "aws-sdk-dlm",
    "v": "1.104.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-dlm-1.104.0"
  },
  {
    "g": "rspec-parameterized",
    "v": "2.0.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/rspec-parameterized-2.0.1"
  },
  {
    "g": "proc_to_ast",
    "v": "0.2.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/proc_to_ast-0.2.0"
  },
  {
    "g": "aws-sigv2",
    "v": "1.3.1",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sigv2-1.3.1"
  },
  {
    "g": "libddwaf",
    "v": "1.30.0.0.2",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/libddwaf-1.30.0.0.2"
  },
  {
    "g": "aws-sdk-kafka",
    "v": "1.113.0",
    "d": "/home/oripekelman/.cache/spinel-compat/gems/aws-sdk-kafka-1.113.0"
  }
]

const REPO = '/home/oripekelman/sites/spinelgems'
const ENGINE = '/srv/data/scratch/spinelgems-rp/spinel-frozen-b60fbd7'
const LEDGER = REPO + '/ledger/harvest12.jsonl'

const SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['gem', 'outcome'],
  properties: {
    gem: { type: 'string' },
    outcome: {
      type: 'string',
      enum: ['verified', 'miscompile-bug', 'codegen-bug', 'loadpath-limit', 'risky-smoke', 'skipped'],
      description: 'verified=cruby==spinel; miscompile-bug=both run but outputs differ; codegen-bug=spinel C-compile error on ordinary Ruby with NO ignored require; loadpath-limit=failure caused by an ignored require (no X.rb)/emitting-0 — known limit, not fileable; risky-smoke=could not make a valid deterministic CRuby smoke; skipped=no testable dep-free API',
    },
    verdict: { type: 'string', description: 'raw verdict word printed by spinel-compat verify' },
    smoke_kept: { type: 'boolean', description: 'true if a smoke file was left in harness/smoke/' },
    diff: { type: 'string', description: 'for miscompile-bug: the L# cruby=.. spinel=.. diff line' },
    error_excerpt: { type: 'string', description: 'for codegen-bug: the C compiler error line(s)' },
    api_tested: { type: 'string', description: 'one-line description of the gem API the smoke exercised' },
    bug_summary: { type: 'string', description: 'for *-bug outcomes: a one-sentence, file-ready description of the Spinel defect' },
  },
}

function prompt(gem, ver, dir) {
  return `You are vetting one RubyGem for the Spinel AOT compiler's behaviour-verification harness. Your job: write a deterministic behaviour smoke that drives this gem's real API, run the differential CRuby-vs-Spinel verifier, and classify the result.

GEM: ${gem}
VERSION: ${ver}
CACHED SOURCE DIR: ${dir}
REPO ROOT: ${REPO}
SMOKE FILE TO WRITE: ${REPO}/harness/smoke/${gem}.rb

## Background you must understand

The verifier compiles a tiny program twice — once under CRuby (reference, with \`-I <dir>/lib\`) and once Spinel-compiled — and diffs stdout. It prepends \`require_relative "lib/${gem}"\` (or the dashed->slashed path) then appends your smoke body. So your smoke must assume the gem's top-level constants are already loaded.

Spinel has NO load path. Two consequences you MUST account for:
- A plain \`require "other_gem"\` or \`require "some/stdlib"\` inside the gem is IGNORED by Spinel (it prints: \`require "X" could not be resolved (no X.rb ...); the call is ignored\`). If your chosen API depends on code behind such an ignored require, Spinel will fail with \`cannot resolve call ... (emitting 0)\` and a runtime \`undefined method\`. That is the KNOWN load-path limitation, NOT a fileable bug.
- Pick an API path that lives in the entrypoint file itself (or files reachable via \`require_relative\`, which Spinel DOES inline), and that needs no external gem and no Spinel-unsupported stdlib.

## Steps

1. Inspect the source: \`ls ${dir}/lib\`, read \`${dir}/lib/${gem}.rb\` (or the dashed->slashed entry), and any \`require_relative\` files. Identify the top-level module/class and a SIMPLE, DETERMINISTIC, dependency-free method or constant you can exercise. Constants and pure string/number/array transforms are ideal. Avoid: time/date/random/RUBY_VERSION/object-ids/hash-ordering-dependent output, network, filesystem, anything needing another gem.

2. Write a short smoke (3-10 \`puts\` lines of stable output) to ${REPO}/harness/smoke/${gem}.rb. Do NOT include the require — the harness adds it. Just drive the API and print.

3. Self-check under CRuby from the repo root:
   \`cd ${REPO} && printf 'require_relative "${dir}/lib/${gem}"\\n' > /tmp/sc_${gem}.rb && cat harness/smoke/${gem}.rb >> /tmp/sc_${gem}.rb && ruby -I ${dir}/lib /tmp/sc_${gem}.rb\`
   It MUST exit 0 with non-empty deterministic output. If it errors (e.g. needs a gem you can't load) or output is non-deterministic, revise the smoke to a different API, or if nothing dep-free is testable, delete the smoke file and return outcome \`skipped\` (or \`risky-smoke\` if the gem simply has no clean CRuby-runnable surface).

4. Run the verifier (this appends to the run ledger; safe in parallel):
   \`cd ${REPO} && SPINEL_DIR=${ENGINE} SPINEL_COMPAT_LEDGER=${LEDGER} ./exe/spinel-compat verify ${gem} ${ver} --dir ${dir} --smoke ${REPO}/harness/smoke/${gem}.rb\`
   Read the final verdict line.

5. Classify into \`outcome\`:
   - \`verified\`: verdict is "verified" (cruby==spinel). KEEP the smoke file. Big win.
   - \`rejected — miscompile\`: both compiled+ran but stdout differs. This is a \`miscompile-bug\`. KEEP the smoke. Capture the \`diff:L# cruby=.. spinel=..\` line into \`diff\`. Write a one-sentence \`bug_summary\`.
   - \`rejected — build-or-run-error\`: inspect WHY. Recompile manually to see warnings:
     \`cd ${dir} && printf 'require_relative "lib/${gem}"\\n' > __sp.rb && cat ${REPO}/harness/smoke/${gem}.rb >> __sp.rb && ${ENGINE}/spinel __sp.rb -o __sp.bin 2>&1 | head -20 ; rm -f __sp.rb __sp.bin\`
       * If you see \`could not be resolved (no X.rb)\` for an external gem/stdlib AND the failing call traces to that ignored require → \`loadpath-limit\`. DELETE the smoke file (low value). Not fileable.
       * If you see a real C compiler error (\`out.c:..: error: ...\`) on ordinary Ruby with NO relevant ignored require → \`codegen-bug\`. KEEP the smoke. Put the \`error:\` line in \`error_excerpt\` and a one-sentence \`bug_summary\`.
   - \`risky\` (smoke-error:cruby): your smoke is broken under CRuby. Try once more to fix it; if still broken, delete the smoke and return \`risky-smoke\`.

6. Set \`smoke_kept\` accurately. Return the structured result. Keep it tight — do not over-investigate; ~one verify + at most one manual recompile. Do NOT file any GitHub issues — bank bug evidence in the structured result only.`
}

phase('Smoke')
const results = await pipeline(
  GEMS,
  (item) => agent(prompt(item.g, item.v, item.d), {
    label: `smoke:${item.g}`,
    phase: 'Smoke',
    model: 'sonnet',
    schema: SCHEMA,
  }),
)

const ok = results.filter(Boolean)
const by = (o) => ok.filter((r) => r.outcome === o)
const summary = {
  total: GEMS.length,
  returned: ok.length,
  verified: by('verified').map((r) => r.gem),
  miscompile_bugs: by('miscompile-bug').map((r) => ({ gem: r.gem, diff: r.diff, bug: r.bug_summary })),
  codegen_bugs: by('codegen-bug').map((r) => ({ gem: r.gem, error: r.error_excerpt, bug: r.bug_summary })),
  loadpath_limit: by('loadpath-limit').length,
  risky_smoke: by('risky-smoke').length,
  skipped: by('skipped').length,
}
log(`verified=${summary.verified.length} miscompile=${summary.miscompile_bugs.length} codegen=${summary.codegen_bugs.length} loadpath=${summary.loadpath_limit} risky=${summary.risky_smoke} skipped=${summary.skipped}`)
return summary
