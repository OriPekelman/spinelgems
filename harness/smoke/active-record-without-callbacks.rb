# Smoke for active-record-without-callbacks 0.0.4
# Test the class is defined and the TRUE_BLOCK constant works
puts ActiveRecordWithoutCallbacks.class
puts ActiveRecordWithoutCallbacks::TRUE_BLOCK.class
puts ActiveRecordWithoutCallbacks::TRUE_BLOCK.call
puts ActiveRecordWithoutCallbacks::TRUE_BLOCK.lambda?
puts ActiveRecordWithoutCallbacks.respond_to?(:wo_callbacks)
