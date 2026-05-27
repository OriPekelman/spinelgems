# Deterministic exercise of diff-lcs: diff + LCS over two sequences.
a = %w[a b c d e f]
b = %w[a c d x f g]
Diff::LCS.diff(a, b).each do |hunk|
  hunk.each { |ch| puts "#{ch.action} #{ch.position} #{ch.element}" }
end
puts "lcs=#{Diff::LCS.lcs(a, b).join(',')}"
puts "sdiff=#{Diff::LCS.sdiff(a, b).map(&:action).join}"
