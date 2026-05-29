puts Scalpel::VERSION
sentences = Scalpel.cut("Hello world. This is a test. Goodbye.")
puts sentences.length
puts sentences[0]
puts sentences[1]
puts sentences[2]
sentences2 = Scalpel.cut("Dr. Smith went to Washington. He met Mr. Jones there.")
puts sentences2.length
puts sentences2[0]
puts sentences2[1]
