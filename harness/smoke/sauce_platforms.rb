h = Platform::Linux_firefox.v10
puts h[:browserName]
puts h[:platform]
puts h[:version]

h2 = Platform::Linux_firefox.v45
puts h2[:browserName]
puts h2[:platform]
puts h2[:version]

h3 = Platform.linux.firefox.v20
puts h3[:browserName]
puts h3[:platform]
puts h3[:version]
