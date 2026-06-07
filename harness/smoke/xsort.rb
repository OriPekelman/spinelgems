require 'xsort'

# Emurate.emurates — extracts the name from a pbxproj comment token
line1 = "        ABC123 /* AppDelegate.swift */,"
puts Xcodeproj::Pbxproj::PbxObject::Emurate.emurates(line1)  # => AppDelegate.swift

line2 = "        DEF456 /* Products */,"
puts Xcodeproj::Pbxproj::PbxObject::Emurate.emurates(line2)  # => Products

# PbxGroup + PbxChild data structures
group = Xcodeproj::Pbxproj::PbxObject::PbxGroup.new
# pbxBase is the raw text including child lines (as parsed from .pbxproj file)
pbx_base = "        GRP001 = {\n" \
           "            children = (\n" \
           "                AA /* zebra.swift */,\n" \
           "                BB /* alpha.swift */,\n" \
           "                CC /* main.swift */,\n" \
           "            );\n" \
           "        };\n"
group.pbxBase = pbx_base
child_z = Xcodeproj::Pbxproj::PbxObject::PbxChild.new("zebra.swift", "                AA /* zebra.swift */,\n")
child_a = Xcodeproj::Pbxproj::PbxObject::PbxChild.new("alpha.swift", "                BB /* alpha.swift */,\n")
child_m = Xcodeproj::Pbxproj::PbxObject::PbxChild.new("main.swift",  "                CC /* main.swift */,\n")
group.children.push(child_z, child_a, child_m)
puts group.children.map(&:name).inspect  # ["zebra.swift", "alpha.swift", "main.swift"]

# PbxSort#psort — sorts children alphabetically; Products pinned last
sorter = Xcodeproj::Pbxproj::PbxObject::PbxSort.new([group])
result = sorter.psort
puts result.length  # 1

sorted_text = result.first
# Sorted order: alpha < main < zebra
alpha_pos = sorted_text.index("BB /* alpha.swift */")
main_pos  = sorted_text.index("CC /* main.swift */")
zebra_pos = sorted_text.index("AA /* zebra.swift */")
puts alpha_pos < main_pos   # true
puts main_pos  < zebra_pos  # true

# Products is pinned last when present
group2 = Xcodeproj::Pbxproj::PbxObject::PbxGroup.new
pbx_base2 = "        GRP002 = {\n" \
            "            children = (\n" \
            "                PP /* Products */,\n" \
            "                QQ /* beta.swift */,\n" \
            "            );\n" \
            "        };\n"
group2.pbxBase = pbx_base2
group2.children.push(
  Xcodeproj::Pbxproj::PbxObject::PbxChild.new("Products", "                PP /* Products */,\n"),
  Xcodeproj::Pbxproj::PbxObject::PbxChild.new("beta.swift", "                QQ /* beta.swift */,\n")
)
result2 = Xcodeproj::Pbxproj::PbxObject::PbxSort.new([group2]).psort
prod_pos = result2.first.index("PP /* Products */")
beta_pos = result2.first.index("QQ /* beta.swift */")
puts beta_pos < prod_pos  # true — Products pinned last

# Option class: parse command-line arguments
opt_o = Option.new(["-o"])
puts opt_o.stdout        # true
puts opt_o.notOverwrite  # false

opt_r = Option.new(["-r"])
puts opt_r.stdout        # false
puts opt_r.notOverwrite  # true

opt_both = Option.new(["-o", "-r"])
puts opt_both.stdout       # true
puts opt_both.notOverwrite # true

# Xsort::VERSION
puts Xsort::VERSION  # 1.4.3
