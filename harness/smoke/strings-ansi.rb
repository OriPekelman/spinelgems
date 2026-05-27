puts Strings::ANSI.sanitize("\e[31mRED\e[0m and \e[1mbold\e[0m text")
puts Strings::ANSI.ansi?("\e[32mgreen\e[0m")
puts Strings::ANSI.ansi?("just plain text")
