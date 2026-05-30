puts PDFTailor.class
puts PDFTailor.respond_to?(:stitch)
puts PDFTailor.respond_to?(:unstitch)
result = PDFTailor.stitch([], {})
puts result.nil?
result2 = PDFTailor.unstitch("", {})
puts result2.nil?
