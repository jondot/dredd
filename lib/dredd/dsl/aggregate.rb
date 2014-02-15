require 'hashie/mash'
require 'statsample'
require 'dredd/dsl/predicate'


module Dredd
  module Dsl
    class Aggregate
      def execute(collection)
        return collection unless @func

        arr = if @projection
          collection.map{|k| Hashie::Mash.new(k) }
                    .map{|k| k.instance_eval(&@projection) }
        else
          (0...collection.size).to_a
        end

        @predicate.execute(arr.to_scale.send(@func))
      end


      def method_missing(meth, *args, &block)
        if [:sum, :mean, :min, :max, :size].include?(meth)
          @func = meth
          @projection = block
          @predicate = Predicate.new
          return @predicate
        else
          super
        end
      end
    end
  end
end

