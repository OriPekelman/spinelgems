# Ununiga: Korean Hangul jaso (character component) splitter
splitter = Ununiga::JasoSplitter.new('흯')
puts splitter.extract_chosung
puts splitter.extract_jungsung
puts splitter.extract_jongsung
puts splitter.split.inspect

splitter2 = Ununiga::JasoSplitter.new('가')
puts splitter2.extract_chosung
puts splitter2.extract_jungsung
puts splitter2.extract_jongsung.inspect
puts splitter2.korean?
