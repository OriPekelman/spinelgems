require 'fileinfo'

# FileInfo.new takes the raw output of `file --mime --brief`,
# so we can construct instances directly without invoking `file`.

# 1. HTML file
html = FileInfo.new("text/html; charset=utf-8")
puts html.content_type
puts html.type
puts html.media_type
puts html.sub_type
puts html.charset

# 2. JPEG image (no charset in MIME line → binary fallback)
jpeg = FileInfo.new("image/jpeg")
puts jpeg.type
puts jpeg.media_type
puts jpeg.sub_type
puts jpeg.charset

# 3. Plain text with US-ASCII charset, test encoding lookup
txt = FileInfo.new("text/plain; charset=us-ascii")
puts txt.charset
enc = txt.encoding
puts enc.name

# 4. Regex constants smoke
puts FileInfo::MIME_TYPE_REGEX.source
puts FileInfo::CHARSET_REGEX.source

# 5. DEFAULT_MIME_TYPE fallback: empty content_type match
empty_fi = FileInfo.new("")
puts empty_fi.type

# 6. UnknownEncodingError is defined and is a StandardError
puts FileInfo::UnknownEncodingError.ancestors.include?(StandardError)
