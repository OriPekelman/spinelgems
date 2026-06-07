require 'betlinks'

# betlinks is a module/mixin; create a host class that includes it
class BetParser
  include Betlinks

  def initialize
    @lang_map = {}
    @records = []
    @current_record = 0
    betlinks_init
  end

  def load_from_string(text)
    # Write to a temp file so bl_read_data can read it
    tmpfile = '/tmp/betlinks_smoke_test.txt'
    File.write(tmpfile, text)
    bl_read_data(tmpfile)
    File.delete(tmpfile)
  end

  def next_record
    bl_data('/tmp/betlinks_smoke_test_dummy.txt')
  end

  def records
    @records
  end
end

# Construct a sample betting fork text in the expected format
sample_data = <<~TEXT
= fork 1 =
5 июня в 18:00
18:00. Спартак - ЦСКА: 3%
1. Bwin; ставка П1 (футбол// Спартак - ЦСКА); коэф. 2,10(футбол// Спартак - ЦСКА)
http://bwin.com/match1
2. Betfair; ставка П2 (теннис// Надаль - Джокович); коэф. 1,95(теннис// Надаль - Джокович)
http://betfair.com/match1

= fork 2 =
6 июня в 20:30
20:30. Манчестер - Арсенал: 5%
1. William Hill; ставка 1X (футбол// Манчестер - Арсенал); коэф. 1,80(футбол// Манчестер - Арсенал)
http://williamhill.com/match2
2. Pinnacle; ставка X2 (футбол// Манчестер - Арсенал); коэф. 2,20(футбол// Манчестер - Арсенал)
http://pinnacle.com/match2
TEXT

parser = BetParser.new

# Test 1: lang_map was populated by betlinks_init
puts "lang_map БЛ_ВИЛКА: #{parser.instance_variable_get(:@lang_map)['БЛ_ВИЛКА']}"
puts "lang_map бл_данные: #{parser.instance_variable_get(:@lang_map)['бл_данные']}"

# Test 2: parse records from the sample text
parser.load_from_string(sample_data)
recs = parser.records
puts "record count: #{recs.length}"

# Test 3: inspect first record fields
if recs.length > 0
  r = recs[0]
  puts "record[0] прибыль: #{r['прибыль']}"
  puts "record[0] брокер_1 имя: #{r['брокер_1']['имя']}"
  puts "record[0] брокер_2 имя: #{r['брокер_2']['имя']}"
  puts "record[0] брокер_1 коэф: #{r['брокер_1']['коэф']}"
  puts "record[0] брокер_2 коэф: #{r['брокер_2']['коэф']}"
end

# Test 4: inspect second record
if recs.length > 1
  r = recs[1]
  puts "record[1] прибыль: #{r['прибыль']}"
  puts "record[1] брокер_1 имя: #{r['брокер_1']['имя']}"
  puts "record[1] брокер_2 имя: #{r['брокер_2']['имя']}"
end

# Test 5: version constant
puts "VERSION: #{Betlinks::VERSION}"
