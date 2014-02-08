require 'hashie/mash'
require 'statsample'


module Dredd
  module Dsl
    class Aggregate
      def execute(collection)
        return collection unless @projection

        arr = collection.map{|k| Hashie::Mash.new(k) }
                        .map{|k| k.instance_eval(&@projection) }

        return arr unless @func

        arr.to_scale.send(@func)
      end


      def method_missing(meth, *args, &block)
        if [:sum, :mean, :min, :max, :size].include?(meth)
          @func = meth
          @projection = block
        else
          super
        end
      end
    end
  end
end

