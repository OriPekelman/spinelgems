# frozen_string_literal: true
# Smoke: pdfkit — Source classification, HTMLPreprocessor path rewriting,
# WkHTMLtoPDF option normalization, configuration defaults. No wkhtmltopdf binary needed.
require 'pdfkit'

# 1. PDFKit::VERSION
puts "version:#{PDFKit::VERSION}"

# 2. PDFKit::Source — URL vs HTML classification
url_src  = PDFKit::Source.new('http://example.com/page')
html_src = PDFKit::Source.new('<html><body>Hello</body></html>')
puts "url?:#{url_src.url?}"
puts "url_html?:#{url_src.html?}"
puts "url_input:#{url_src.to_input_for_command}"
puts "html_url?:#{html_src.url?}"
puts "html_html?:#{html_src.html?}"
puts "html_input:#{html_src.to_input_for_command}"

# 3. PDFKit::HTMLPreprocessor — relative-path → absolute-path rewriting
raw = '<img src="/images/logo.png"><a href="/about">About</a>'
puts "rewrite_path:#{PDFKit::HTMLPreprocessor.process(raw, 'https://example.com/', nil)}"

# 4. PDFKit::HTMLPreprocessor — protocol-relative → explicit protocol
raw2 = '<img src="//cdn.example.com/img.png"><a href="//cdn.example.com/link">Link</a>'
puts "rewrite_proto:#{PDFKit::HTMLPreprocessor.process(raw2, nil, 'https')}"

# 5. PDFKit::HTMLPreprocessor — no root_url and no protocol → identity
raw3 = '<img src="/path/img.jpg">'
puts "identity:#{PDFKit::HTMLPreprocessor.process(raw3, nil, nil)}"

# 6. PDFKit::WkHTMLtoPDF — option normalization (no binary needed)
renderer = PDFKit::WkHTMLtoPDF.new(
  page_size:               'A4',
  margin_top:              '1in',
  quiet:                   true,
  disable_smart_shrinking: false
)
renderer.normalize_options
opts = renderer.options
puts "page_size:#{opts['--page-size']}"
puts "margin_top:#{opts['--margin-top']}"
# quiet:true → nil value (flag with no argument)
puts "quiet_nil:#{opts['--quiet'].nil?}"
# false value → option is skipped entirely
puts "shrink_absent:#{!opts.key?('--disable-smart-shrinking')}"

# 7. PDFKit::WkHTMLtoPDF — repeatable option (cookie Hash)
renderer2 = PDFKit::WkHTMLtoPDF.new(cookie: { 'session' => 'abc123' })
renderer2.normalize_options
flat = renderer2.options_for_command
puts "cookie_flag:#{flat.include?('--cookie')}"
puts "cookie_key:#{flat.include?('session')}"
puts "cookie_val:#{flat.include?('abc123')}"

# 8. PDFKit.configuration defaults
cfg = PDFKit.configuration
puts "meta_prefix:#{cfg.meta_tag_prefix}"
puts "encoding:#{cfg.default_options[:encoding]}"
puts "page_size_default:#{cfg.default_options[:page_size]}"
puts "verbose:#{cfg.verbose?}"
puts "xvfb:#{cfg.using_xvfb?}"
