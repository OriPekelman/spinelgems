puts CaseTransform.unaltered("hello")
puts CaseTransform.unaltered(42)
puts CaseTransform.unaltered(nil).inspect
puts CaseTransform.unaltered(:symbol).inspect
puts CaseTransform.unaltered([1, 2, 3]).inspect
