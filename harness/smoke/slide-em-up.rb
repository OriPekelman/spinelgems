# Smoke: slide-em-up
# Tests SlideEmUp::Markdown renderer callbacks (normal_text, strikethrough)
# and SlideEmUp::Presentation::Slide struct (extract_title, html mutation).
# External C-extension deps (redcarpet, pygments, erubis, yajl) are stubbed
# inline; $LOADED_FEATURES is pre-seeded so CRuby's require skips their files.
# Under Spinel, plain `require` of other gems is silently ignored anyway.

# Pre-seed $LOADED_FEATURES so CRuby skips the real require for each dep
%w[pygments redcarpet redcarpet/compat erubis yajl].each do |f|
  $LOADED_FEATURES << f unless $LOADED_FEATURES.include?(f)
end

# Stub redcarpet (C extension — not available without native build)
module Redcarpet
  VERSION = "3.6.1"
  class Markdown
    def initialize(renderer, opts = {}); @renderer = renderer; end
    def render(text); text.to_s; end
  end
  module Render
    class HTML; end
  end
end

# Stub pygments (requires Python / C bridge)
module Pygments
  def self.highlight(code, opts = {}); code; end
end

# Stub erubis (template engine — only used in Presentation#html, not smoked here)
module Erubis
  class Eruby
    def initialize(str); @str = str; end
    def result(bindings = nil); @str; end
  end
end

# Stub yajl (C JSON extension — only used in Presentation#initialize, not smoked)
module Yajl
  module Parser
    def self.parse(str); {}; end
  end
end

require "slide-em-up"

# --- Test 1: SlideEmUp::Markdown#normal_text — French typography substitutions ---
renderer = SlideEmUp::Markdown.new
puts renderer.normal_text("Hello « world !").inspect
# « substitution: « +   before !

puts renderer.normal_text("This is ... great -- seriously").inspect
# ... -> … and  -- -> —

puts renderer.normal_text("foo : bar ; baz ! qux ?").inspect
# &nbsp; before each punctuation character

# --- Test 2: SlideEmUp::Markdown#strikethrough ---
puts renderer.strikethrough("deleted text").inspect

# --- Test 3: SlideEmUp::Presentation::Slide — Struct accessors and extract_title ---
slide = SlideEmUp::Presentation::Slide.new(0, "cover", "<h1>My Great Talk</h1><p>intro</p>")
puts slide.number
puts slide.classes
puts slide.extract_title.inspect
# html should have the h1 tag stripped after extract_title is called
puts slide.html

# --- Test 4: Slide with h2 heading ---
slide2 = SlideEmUp::Presentation::Slide.new(1, "section", "<h2>Sub Section</h2><p>body</p>")
puts slide2.extract_title.inspect
puts slide2.html

# --- Test 5: Slide with no heading — extract_title returns nil ---
slide3 = SlideEmUp::Presentation::Slide.new(2, "plain", "<p>No heading here</p>")
puts slide3.extract_title.inspect
puts slide3.html
