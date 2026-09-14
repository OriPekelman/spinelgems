# FILED as matz/spinel#3320 (2026-07-24). FIXED upstream same day (13ab61b1);
# verified at 681b08ae — guard false, matching CRuby. Residual: defined? on a
# conditionally-defined (hoisted) class still answers statically — DOCUMENTED
# divergence (docs/limitations.md), smoke adjusted, not filed.
module Underscore
  module Rails
    if defined?(::Rails)
      puts "guard TRUE"
    else
      puts "guard false"
    end
  end
end
