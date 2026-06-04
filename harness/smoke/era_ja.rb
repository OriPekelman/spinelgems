# smoke: era_ja — Japanese era conversion on Date and Time
require 'era_ja'

# 1. Reiwa era (current)
d = Date.new(2019, 5, 1)
puts d.to_era                            # R01.05.01 (default format)
puts d.to_era("%O%E年%m月%d日")          # 令和01年05月01日

# 2. Heisei era
d2 = Date.new(2019, 4, 30)
puts d2.to_era("%O%E年%m月%d日")         # 平成31年04月30日
puts d2.to_era("%o%-E.%m.%d")           # H31.04.30 (no leading zero on year)

# 3. Showa era
d3 = Date.new(1989, 1, 7)
puts d3.to_era("%O%E年%m月%d日")         # 昭和64年01月07日

# 4. era_convertible? predicate
puts Date.new(1868, 9, 8).era_convertible?   # true (boundary)
puts Date.new(1868, 9, 7).era_convertible?   # false (before Meiji)

# 5. Time#to_era
t = Time.mktime(2024, 1, 15)
puts t.to_era("%O%-E年%m月%d日")         # 令和6年01月15日

# 6. Kanji year format (%K = 元 for year 1, then numeric)
puts Date.new(2019, 5, 1).to_era("%O%KE年")   # 令和元E年 (year 1 → 元)
puts Date.new(2020, 1, 1).to_era("%O%KE年")   # 令和二E年 (year 2 → kanji)
