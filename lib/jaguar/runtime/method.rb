module Jaguar

  class JaguarMethod
    attr_accessor :name, :body
    def initialize(params, body, name="")
      @params = params
      @body = body
      @name = name
    end

    def call(receiver, arguments)
      context = Context.new(receiver)
      context.set_current_method(self)

      @params.each_with_index do |param, index|
        context.locals[param] = arguments[index]
      end

      @body.eval(context)
    end
  end

end
