module Jaguar

  jaguar_class = JaguarClass.new
  jaguar_class.runtime_class = jaguar_class
  object_class = JaguarClass.new
  object_class.runtime_class = jaguar_class

  Runtime = Context.new(object_class.new)

  Runtime["Class"] = jaguar_class
  Runtime["Object"] = object_class
  Runtime["Number"] = JaguarClass.new
  Runtime["String"] = JaguarClass.new

  Runtime["TrueClass"] = JaguarClass.new
  Runtime["FalseClass"] = JaguarClass.new
  Runtime["NullClass"] = JaguarClass.new

  Runtime["true"] = Runtime["TrueClass"].new_with_value(true)
  Runtime["false"] = Runtime["FalseClass"].new_with_value(false)
  Runtime["null"] = Runtime["NullClass"].new_with_value(nil)

  Runtime["Class"].runtime_methods["new"] = proc do |receiver, arguments|
    receiver.new
  end

  Runtime["Object"].runtime_methods["print"] = proc do |receiver, arguments|
    puts arguments.first.ruby_value
    Runtime["null"]
  end

end