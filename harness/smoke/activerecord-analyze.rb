# Smoke: activerecord-analyze -- test module constant existence
# VERSION is in a separate file not loaded by main entry; check module is defined
puts ActiveRecordAnalyze.class
puts ActiveRecordAnalyze.respond_to?(:build_prefix)
puts ActiveRecordAnalyze.respond_to?(:analyze_sql)
