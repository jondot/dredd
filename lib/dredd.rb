require "dredd/version"
require 'dredd/query'

module Dredd
  def self.detect(query, values)
    Query.new(query).execute(values)
  end
end
