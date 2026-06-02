puts Metaclass::VERSION
obj = Object.new
puts obj.__metaclass__ == obj.singleton_class ? "obj_singleton_ok" : "obj_singleton_fail"
puts obj.__metaclass__.is_a?(Class) ? "is_class" : "not_class"
puts Metaclass::ObjectMethods.instance_method(:__metaclass__).name
