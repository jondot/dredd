module Dredd
  module Dsl
    class Predicate
      MAP = {
        :is => :==,
        :lt => :<,
        :gt => :>
      }
      def execute(val)
        return val unless @func 
        return val.send(*@func)
      end


      def method_missing(meth, *args, &block)
        if [:is, :lt, :gt].include?(meth)
          @func = [MAP[meth], *args]
        else
          super
        end
      end
    end
  end
end

