puts Requirable::VERSION
puts Requirable.dir_list("/nonexistent_path_xyz/**/*.rb").inspect
puts Requirable.dir_list("/nonexistent_path_xyz/**/*.rb").length
