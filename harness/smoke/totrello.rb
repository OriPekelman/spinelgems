require 'totrello/version'
require 'totrello/trello_config'
require 'totrello/todos'

# --- TrelloConfig defaults ---
# Bypass file loading (no .totrello.yml) by using allocate + manual defaults
config = TrelloConfig.allocate
config.instance_variable_set(:@project_name, nil)
config.instance_variable_set(:@board_name, nil)
config.instance_variable_set(:@default_list, nil)
config.instance_variable_set(:@excludes, nil)
config.instance_variable_set(:@todo_types, nil)
config.instance_variable_set(:@file_types, nil)
config.instance_variable_set(:@comment_style, nil)
config.send(:default_config, '/some/path/myproject')

puts config.project_name    # => myproject
puts config.board_name      # => myproject
puts config.default_list    # => To Do
puts config.file_types.sort.inspect   # => [".erb", ".rb"]
puts config.todo_types.sort.inspect   # => ["#TODO", "#TODO:", "TODO", "TODO:"]
puts config.comment_style.inspect     # => ["#"]

# --- Todos: todo? predicate ---
todos = Todos.new

puts todos.todo?("# TODO fix this", config)   # => true
puts todos.todo?("# FIXME fix this", config)  # => false
puts todos.todo?("", config)                  # => false
puts todos.todo?("x = 1  # TODO: refactor", config)  # => false (doesn't start with #)

# --- Todos: clean_todo ---
t = Todos.new
line1 = "# TODO: clean this up\n"
result = t.clean_todo(line1.dup, config)
puts result.inspect   # => "clean this up"

line2 = "# TODO fix later\n"
result2 = t.clean_todo(line2.dup, config)
puts result2.inspect  # => "fix later"

# --- description helper (inline, no Trelloize to avoid TrelloBuilder+trello dep) ---
def description(todo, config)
  return '' if todo.nil?
  out =  'TODO item found by the '
  out += "[ToTrello](https://rubygems.org/gems/totrello) gem\n"
  out += "**Project name:** #{config.project_name}\n"
  out += "**Filename**: #{todo[:file]}\n"
  out += "**Action item**: #{todo[:todo]}\n"
  out + "**Location (at or near) line**: #{todo[:line_number]}\n"
end

todo_item = { file: 'app/foo.rb', todo: 'write tests', line_number: 42 }
desc = description(todo_item, config)
puts desc.include?('myproject')   # => true
puts desc.include?('write tests') # => true
puts desc.include?('42')          # => true
