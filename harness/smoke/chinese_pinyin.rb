# Smoke test for chinese_pinyin gem
puts ChinesePinyin::VERSION
puts Pinyin::TONE_MARK[:a].join(',')
puts Pinyin::TONE_MARK[:i].join(',')
puts Pinyin.translate('中')
puts Pinyin.translate('北京', splitter: '-')
puts Pinyin.translate('你好')
