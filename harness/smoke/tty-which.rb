puts(TTY::Which.exist?("sh"))
puts(TTY::Which.which("definitely-not-a-real-binary-xyz").nil?)
