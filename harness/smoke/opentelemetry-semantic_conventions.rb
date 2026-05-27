m = OpenTelemetry::SemanticConventions::Trace::HTTP_METHOD
s = OpenTelemetry::SemanticConventions::Trace::HTTP_STATUS_CODE
puts m
puts s
puts m.length
puts(m == "http.method")
