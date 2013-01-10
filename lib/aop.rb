#
#https://github.com/mlen
#
module AOP
  def before_all(object, &block)
    fns = [object.class.instance_methods - Object.methods]
    fns.each do |symbol|
      puts symbol
      #before(object, symbol, &block)
    end
  end

  def before(object, symbol, &block)
    original = object.method(symbol)

    object.define_singleton_method symbol do |*args|
      block.call(*args)
      original.call(*args)
    end
  end

  def after(object, symbol, &block)
    original = object.method(symbol)

    object.define_singleton_method symbol do |*args|
      original.call(*args)
      block.call(*args)
    end
  end

  def around(object, symbol, &block)
    original = object.method(symbol)

    object.define_singleton_method symbol do |*args|
      block.call(original, *args)
    end
  end
end


module AOPExample

  class A
    def foo
      puts "foo"
    end
  end

  def try_me
    a = A.new

    before a, :foo do
      puts "sth before"
    end

    after a, :foo do
      puts "sth after"
    end

    around a, :foo do |original|
      puts "sth around-before"
      original.call
      puts "sth around-after"
    end
    a.foo
  end

end

include AOP

#include AOPExample
#AOPExample::try_me
