require 'spec_helper'
require 'dredd'

BAD_VALS = [
  { :rate => 0 },
  { :rate => 0 },
  { :rate => 0 },
  { :rate => 40 },
  { :rate => 0 }
]

describe Dredd do
  it "should detect bad values" do
    query = "all{ rate > 0 }.max{ rate }"
    result = Dredd.detect(query, BAD_VALS)
    result.must_equal(40)
  end
end
