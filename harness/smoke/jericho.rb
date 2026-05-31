# Smoke test for jericho 0.3.0

# Build a fake parsed_report for reporter
report1 = [
  {
    'elements' => [
      {
        'name' => 'Login',
        'steps' => [
          { 'result' => { 'status' => 'passed' } },
          { 'result' => { 'status' => 'passed' } }
        ]
      },
      {
        'name' => 'Logout',
        'steps' => [
          { 'result' => { 'status' => 'passed' } },
          { 'result' => { 'status' => 'failed' } }
        ]
      }
    ]
  }
]

result1 = Jericho.reporter(report1)
puts result1['Login']
puts result1['Logout']

report2 = [
  {
    'elements' => [
      {
        'name' => 'Login',
        'steps' => [
          { 'result' => { 'status' => 'passed' } }
        ]
      },
      {
        'name' => 'Signup',
        'steps' => [
          { 'result' => { 'status' => 'failed' } }
        ]
      }
    ]
  }
]

result2 = Jericho.reporter(report2)
puts result2['Login']
puts result2['Signup']

comparison = Jericho.comparison_reporter(result1, result2)
puts comparison[:passed]
puts comparison[:failed]
puts comparison[:failed_tests].first[:test_name]
puts comparison[:failed_tests].first[:actual_status]
