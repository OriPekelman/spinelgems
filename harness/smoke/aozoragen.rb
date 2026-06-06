# smoke: aozoragen — Aozora Bunko format string conversions
# The pure string-conversion logic (han2zen, for_tategaki, subhead,
# normalize_char) lives in util.rb behind a `require 'nokogiri'`.
# Spinel ignores external gem requires, so it inlines the Ruby logic fine.
# Under CRuby we inline the same pure methods directly in the smoke so
# that the test runs without nokogiri installed.

require 'aozoragen'

# Inline the pure-Ruby string extensions from aozoragen/util.rb so the
# smoke is self-contained (nokogiri is not needed for these methods).
unless ''.respond_to?(:han2zen)
  class String
    def han2zen
      tr('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,/?',
         'ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ０１２３４５６７８９．，／？')
    end

    def for_tategaki
      tr('＜＞－""−', '∧∨―〃〃‐').han2zen
    end

    def subhead
      split(/\n/).map { |x|
        "\n［＃小見出し］#{x}［＃小見出し終わり］"
      }.join + "\n\n"
    end

    def normalize_char
      tr("～〝〟嚙頰剝瘦摑噓繫－搔吞蠟啞鹼",
         "〜〃〃噛頬剥痩掴嘘繋─掻呑蝋唖鹸")
    end

    def fix_aozora_notation
      gsub(/[｜|](.+?)『(.+?)』/) { "｜#{$1}《#{$2}》" }
    end
  end
end

puts Aozoragen::VERSION

# han2zen: half-width ASCII → full-width
puts 'Hello, World! 123'.han2zen

# for_tategaki: fullwidth special chars → tategaki equivalents + han2zen
# ＜→∧  ＞→∨  －→―
puts 'abc＜＞－'.for_tategaki

# subhead: wrap line in Aozora section-heading markup
puts 'Chapter One'.subhead.strip

# normalize_char: normalize rare Unicode variant characters
# U+FF5E FULLWIDTH TILDE → U+301C WAVE DASH, etc.
puts "～吞瘦".normalize_char

# fix_aozora_notation: convert ruby annotation brackets to Aozora style
puts '｜東京『とうきょう』へ'.fix_aozora_notation
puts '|大阪『おおさか』です'.fix_aozora_notation
