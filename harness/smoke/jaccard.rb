a = [1, 2, 3, 4]
b = [1, 3, 4]
puts Jaccard.coefficient(a, b)
puts Jaccard.distance(a, b)

x = [1, 2, 3]
y = [1, 2]
z = [1, 3]
puts Jaccard.coefficient(x, y)
puts Jaccard.coefficient(x, z)
puts Jaccard.distance(y, z)

# closest_to
puts Jaccard.closest_to([1, 2], [[1, 2, 3], [1, 2]]).inspect
