# activestorage-aliyun smoke: test module definition only (entry file is minimal)
puts ActiveStorageAliyun.class
puts ActiveStorageAliyun.is_a?(Module)
puts ActiveStorageAliyun.name
puts ActiveStorageAliyun.ancestors.include?(ActiveStorageAliyun)
