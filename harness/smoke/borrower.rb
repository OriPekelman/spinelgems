require 'borrower'

# borrower's Manifest uses File.exists? (removed in Ruby 3.2+) which blows
# up at Manifest.new. We exercise the Merge class, which is fully
# self-contained pure string logic, and the CommentSymbol sub-module.
# For inline-substitution we stub Content.get before the merge fires.

# --- 1. Merge#output passthrough (no borrow statements) ---
content1 = "# some text\n# more text\n"
m1 = Borrower::Merge.new(content1)
puts m1.output == content1 ? "merge_passthrough:ok" : "merge_passthrough:FAIL"

# --- 2. Merge with JS comment type (// delimiter) ---
content2 = "// hello\n// world\n"
m2 = Borrower::Merge.new(content2, type: "js")
puts m2.output == content2 ? "merge_js_passthrough:ok" : "merge_js_passthrough:FAIL"

# --- 3. Merge with CSS type ---
m3 = Borrower::Merge.new("/* no borrow here */", type: "css")
puts m3.output == "/* no borrow here */" ? "merge_css_passthrough:ok" : "merge_css_passthrough:FAIL"

# --- 4. CommentSymbol.find_symbol_for ---
sym_default  = Borrower::Merge::CommentSymbol.find_symbol_for("default")
sym_js       = Borrower::Merge::CommentSymbol.find_symbol_for("js")
sym_css      = Borrower::Merge::CommentSymbol.find_symbol_for("css")
sym_unknown  = Borrower::Merge::CommentSymbol.find_symbol_for("unknown")  # => "#"
puts "comment_default:#{sym_default}"
puts "comment_js:#{sym_js}"
puts "comment_css:#{sym_css}"
puts "comment_unknown:#{sym_unknown}"

# --- 5. Merge inline substitution (stub Content.get entirely) ---
# We stub Content.get so the merge resolves without hitting Manifest/File.exists?
module Borrower
  class Content
    class << self
      def get path
        "SNIPPET[#{path}]"
      end
    end
  end
end

content5 = "before\n#= borrow '__STUB__'\nafter\n"
m5 = Borrower::Merge.new(content5)
out5 = m5.output
puts out5.include?("SNIPPET[__STUB__]") ? "merge_inline_sub:ok" : "merge_inline_sub:FAIL"
puts out5.include?("before") && out5.include?("after") ? "merge_inline_surround:ok" : "merge_inline_surround:FAIL"

# --- 6. Merge with explicit :comment option ---
content6 = "// line\n//= borrow 'myfile'\nend"
m6 = Borrower::Merge.new(content6, comment: "//")
out6 = m6.output
puts out6.include?("SNIPPET[myfile]") ? "merge_custom_comment:ok" : "merge_custom_comment:FAIL"
puts !out6.include?("//= borrow") ? "merge_custom_comment_removed:ok" : "merge_custom_comment_removed:FAIL"
