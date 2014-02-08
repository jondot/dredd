require 'hashie'
require 'dredd/dsl/aggregate'

module Dredd
  class Query
    attr_reader :window

    def initialize(text)
      instance_eval(text)
    end

    def all(&block)
      @window = [:to_a]
      @filter = block
      @aggregate = Dsl::Aggregate.new
    end

    def first(num, &block)
      @window = [:first, num]
      @filter = block
      @aggregate = Dsl::Aggregate.new
    end

    def last(num, &block)
      @window = [:last, num]
      @filter = block
      @aggregate = Dsl::Aggregate.new
    end

    def execute(collection)
      slice = collection.send(*@window)
                .map{|k| Hashie::Mash.new(k)}
                .select{|k| @filter ? k.instance_eval(&@filter) : true }
                .map{|k| k.to_hash }
      @aggregate.execute(slice)
    end
  end
end
