require_relative "lib/jkl/text_client"

puts Jkl::Text.strip_all_tags("<p>Hello <b>world</b></p>")
puts Jkl::Text.strip_all_tags("<div class=\"x\">foo</div>")
puts Jkl::Text.remove_html_comments("<!-- comment -->keep")
puts Jkl::Text.remove_blank_lines("line1\nline2\nline3")
puts Jkl::Text.remove_script_tags("<script>alert(1)</script>text")
