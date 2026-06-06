# frozen_string_literal: true
# Smoke test for linked-list gem — exercises push/pop/shift/unshift/insert/delete/each
require 'linked-list'

# Build a list by pushing elements
list = LinkedList::List.new
list.push(10)
list.push(20)
list.push(30)
list.push(40)

puts list.length        # 4
puts list.first         # 10
puts list.last          # 40
puts list.to_a.inspect  # [10, 20, 30, 40]

# << alias for push
list << 50
puts list.last          # 50
puts list.length        # 5

# unshift prepends
list.unshift(5)
puts list.first         # 5
puts list.length        # 6

# shift removes from front
val = list.shift
puts val                # 5
puts list.first         # 10

# pop removes from end
val = list.pop
puts val                # 50
puts list.last          # 40
puts list.length        # 4

# insert after
list2 = LinkedList::List.new
list2.push('a')
list2.push('b')
list2.push('c')
list2.insert('bb', after: 'b')
puts list2.to_a.inspect # ["a", "b", "bb", "c"]
puts list2.length       # 4

# insert before
list2.insert('aa', before: 'a')
puts list2.to_a.inspect # ["aa", "a", "b", "bb", "c"]

# delete a value
list2.delete('bb')
puts list2.to_a.inspect # ["aa", "a", "b", "c"]

# delete_all
list3 = LinkedList::List.new
list3.push(1)
list3.push(2)
list3.push(2)
list3.push(3)
deleted = list3.delete_all(2)
puts deleted.inspect    # [2, 2]
puts list3.to_a.inspect # [1, 3]
puts list3.length       # 2

# each enumeration
list4 = LinkedList::List.new
list4 << 'x'
list4 << 'y'
list4 << 'z'
collected = []
list4.each { |d| collected << d }
puts collected.inspect  # ["x", "y", "z"]

# reverse_each
rev_collected = []
list4.reverse_each { |d| rev_collected << d }
puts rev_collected.inspect # ["z", "y", "x"]

# size alias
puts list4.size         # 3

# each_node yields Node objects
list4.each_node { |n| print n.data.to_s + ' ' }
puts                    # x y z

# Node direct construction
node = LinkedList::Node.new(42)
puts node.data          # 42
puts node.next.inspect  # nil
puts node.prev.inspect  # nil
