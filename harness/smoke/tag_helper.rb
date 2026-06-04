require 'tag_helper'

include TagHelper

# unary tag with no attributes
puts tag(:br)
# => <br />

# unary tag with attributes
puts tag(:img, src: '1.png', alt: 'number one!')
# => <img src="1.png" alt="number one!" />

# content tag via block
puts tag(:label, for: 'name') { 'Name' }
# => <label for="name">Name</label>

# content tag with nil attribute (nil values are dropped)
puts tag(:input, type: 'text', disabled: nil)
# => <input type="text" />

# nested tags using blocks
puts tag(:div) {
  tag(:form) {
    tag(:input, type: 'text')
  }
}
# => <div><form><input type="text" /></form></div>

# TagHelper used directly as module (extend self)
puts TagHelper.tag(:span, class: 'highlight') { 'hello' }
# => <span class="highlight">hello</span>
