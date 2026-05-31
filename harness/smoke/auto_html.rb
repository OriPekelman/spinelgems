# Smoke: auto_html - Pipeline, SimpleFormat, Image, TagHelper (no external deps)

# TagHelper.tag - unary tag
puts AutoHtml::TagHelper.tag(:img, src: "http://example.com/photo.jpg", alt: "photo")

# TagHelper.tag with block - content tag
puts AutoHtml::TagHelper.tag(:p) { "Hello world" }

# TagHelper.tag with no attrs
puts AutoHtml::TagHelper.tag(:br)

# SimpleFormat filter
sf = AutoHtml::SimpleFormat.new
puts sf.call("Hello world\n\nSecond paragraph")

# Pipeline with SimpleFormat
pipeline = AutoHtml::Pipeline.new(AutoHtml::SimpleFormat.new)
puts pipeline.call("Line one\n\nLine two")

# Pipeline empty/nil handling
puts pipeline.call("").inspect
puts pipeline.call(nil).inspect

# Image filter transforms image URLs
img_filter = AutoHtml::Image.new
puts img_filter.call("Check this out: http://example.com/pic.png")

# Image filter with alt text
img_filter2 = AutoHtml::Image.new(alt: "cool")
puts img_filter2.call("Look: http://example.com/image.jpg")
