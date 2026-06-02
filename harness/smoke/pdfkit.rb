# Smoke: pdfkit — exercises VERSION constant and HTMLPreprocessor pure string methods
puts PDFKit::VERSION

html = '<img src="/images/logo.png"><a href="/about">About</a>'
puts PDFKit::HTMLPreprocessor.process(html, 'https://example.com/', nil)
puts PDFKit::HTMLPreprocessor.process(html, nil, 'https')

html2 = '<img src="//cdn.example.com/img.png"><a href="//cdn.example.com/link">Link</a>'
puts PDFKit::HTMLPreprocessor.process(html2, nil, 'https')

html3 = '<img src="/path/to/img.jpg">'
puts PDFKit::HTMLPreprocessor.process(html3, 'http://localhost:3000/', nil)
