# cucumber-websteps smoke test
# Main entry is a stub (prevents bundler auto-load). Real content: Cucumber step
# definitions (require Capybara+Cucumber runtime). We test the pure Ruby logic:
# form-field type-dispatch regex patterns (from form_steps.rb) and step text matching
# (from browsing_steps.rb). Uses explicit match objects to avoid $1 global captures.

require 'cucumber-websteps'  # stub file, safe to require

# Form-field type-dispatch regexes (from form_steps.rb)
select_tag    = /^(?<n>.+\S+)\s*(?:\(select\))$/
check_box_tag = /^(?<n>.+\S+)\s*(?:\(checkbox\))$/
radio_button  = /^(?<n>.+\S+)\s*(?:\(radio\))$/
file_field    = /^(?<n>.+\S+)\s*(?:\(file\))$/

fields = [
  ["Account Number",                   "5002"],
  ["Expiry date",                      "2009-11-01"],
  ["Sex                  (select)",    "Male"],
  ["Accept user agrement (checkbox)",  "check"],
  ["Send me letters      (checkbox)",  "uncheck"],
  ["radio 1              (radio)",     "choose"],
  ["Avatar               (file)",      "avatar.png"],
]

fields.each do |name, value|
  if (m = select_tag.match(name))
    puts "select[#{m[:n].strip}]"
  elsif (m = check_box_tag.match(name))
    puts "checkbox[#{m[:n].strip}]=#{value}"
  elsif (m = radio_button.match(name))
    puts "radio[#{m[:n].strip}]"
  elsif (m = file_field.match(name))
    puts "file[#{m[:n].strip}]"
  else
    puts "text[#{name}]=#{value}"
  end
end

# Browsing step regex patterns (from browsing_steps.rb)
patterns = {
  on_page:    /^(?:|I )am on (.+)$/,
  go_to:      /^(?:|I )go to (.+)$/,
  follow:     /^(?:|I )follow "([^"]*)"$/,
  should_see: /^(?:|I )should see "([^"]*)"$/,
  regexp_see: /^(?:|I )should see \/([^\/]*)\/([imxo])?$/,
}

steps = [
  ["I am on the home page",   :on_page],
  ["I go to the login page",  :go_to],
  ['I follow "Sign in"',      :follow],
  ['I should see "Welcome"',  :should_see],
  ["I should see /hello/i",   :regexp_see],
]

steps.each do |text, key|
  m = patterns[key].match(text)
  puts "match[#{key}]: #{m ? m.captures.compact.join('|') : 'NONE'}"
end
