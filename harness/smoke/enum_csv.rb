# Smoke: enum_csv — drive EnumCSV.csv with simple array data
data = [["Alice", 30], ["Bob", 25]]
result = EnumCSV.csv(data, headers: ["name", "age"])
puts result.strip
puts EnumCSV.csv([["x", "1"], ["y", "2"]]).strip
