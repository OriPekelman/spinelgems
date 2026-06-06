require 'red_blocks'

# --- Config defaults ---
cfg = RedBlocks.config
puts cfg.key_namespace          # => RB
puts cfg.blank_id               # => 0
puts cfg.intermediate_set_lifetime  # => 30
puts cfg.infinity.infinite?     # => true (1 means +infinity)
puts cfg.infinity.infinite? == 1  # => true

# --- Expression ---
exp = RedBlocks::Expression.new('my_key', score: 0.5, weight: 2.0, label: 'relevance')
puts exp.key                    # => my_key
puts exp.label                  # => relevance
puts exp.to_s                   # => 1.0000[relevance]

exp2 = RedBlocks::Expression.new('other', score: 0.25)
puts exp2.label                 # => other (falls back to key)
puts exp2.to_s                  # => 0.2500[other]

# --- Expression with no label (falls back to key) ---
exp3 = RedBlocks::Expression.new('fallback_key', score: 1.0, weight: 1)
puts exp3.label                 # => fallback_key
puts exp3.to_s                  # => 1.0000[fallback_key]

# --- ComposedExpression (sum) ---
operands = [
  RedBlocks::Expression.new('a', score: 0.3),
  RedBlocks::Expression.new('b', score: 0.7),
]
composed = RedBlocks::ComposedExpression.new('composed_key', operator: :sum, operands: operands)
puts composed.operator          # => sum
puts composed.operands.size     # => 2
puts composed.to_s              # => 0.3000[a] + 0.7000[b]

# --- ComposedExpression (non-sum, weighted) ---
composed2 = RedBlocks::ComposedExpression.new('c2', operator: :max, operands: operands, weight: 3)
str = composed2.to_s
puts str.include?('max(')       # => true
puts str.include?('* 3')        # => true

# --- Paginator ---
pag = RedBlocks::Paginator.new(per: 10, page: 1)
puts pag.head                   # => 0
puts pag.tail                   # => 9
puts pag.size                   # => 10

pag2 = RedBlocks::Paginator.new(per: 5, page: 3)
puts pag2.head                  # => 10
puts pag2.tail                  # => 14
puts pag2.size                  # => 5

pag3 = RedBlocks::Paginator.new(head: 2, tail: 7)
puts pag3.head                  # => 2
puts pag3.tail                  # => 7
puts pag3.size                  # => 6

all = RedBlocks::Paginator.all
puts all.head                   # => 0
puts all.tail                   # => -1

# --- SetUtils.joined_key (class-level utility) ---
class DummySet
  include RedBlocks::SetUtils
end
puts DummySet.joined_key(['user', 42, 'score'])           # => user:42:score
puts DummySet.joined_key(['a', 'b'], sep: '-')            # => a-b
puts DummySet.joined_key(['x', 'y'], wrap: true)          # => [x]:[y]
