scores = {
  "alice" => { "item1" => 5.0, "item2" => 3.0, "item3" => 4.0 },
  "bob"   => { "item1" => 3.0, "item2" => 5.0, "item3" => 2.0 },
  "carol" => { "item1" => 4.0, "item2" => 4.0, "item3" => 5.0 }
}

# coefficient between alice and carol (should be positive, correlated)
c1 = Pearson.coefficient(scores, "alice", "carol")
puts c1.round(6)

# coefficient between alice and bob (should be different)
c2 = Pearson.coefficient(scores, "alice", "bob")
puts c2.round(6)

# coefficient with no shared items returns 0
empty_scores = { "x" => { "a" => 1.0 }, "y" => { "b" => 2.0 } }
puts Pearson.coefficient(empty_scores, "x", "y")

# closest entities for alice, limited to 1
closest = Pearson.closest_entities(scores, "alice", limit: 1)
puts closest.first.first
