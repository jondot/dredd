require 'dredd/query'

describe Dredd::Query do
  it "should execute an all query" do
    q = Dredd::Query.new("all{ foo > 50 }")
    q.execute([{:foo  => 0}, {:foo => 60}]).must_equal(["foo" => 60])
  end

  it "should execute a limiting query" do
    q = Dredd::Query.new("first(2){ foo > 50 }")
    q.execute([{:foo  => 0},{:foo  => 0}, {:foo => 60}]).must_equal([])

    q = Dredd::Query.new("last(2){ foo > 50 }")
    q.execute([{:foo  => 0},{:foo  => 0}, {:foo => 60}]).must_equal(["foo" => 60])
  end

  it "should select first" do
    q = Dredd::Query.new("first(1){ foo }")
    q.execute([{:foo  => 0}, {:foo => 60}]).must_equal(["foo" => 0])
  end

  it "should select last" do
    q = Dredd::Query.new("last(1){ foo }")
    q.execute([{:foo  => 0}, {:foo => 60}]).must_equal(["foo" => 60])
  end

  it "should run aggregations on all" do
    q = Dredd::Query.new("all.sum{ foo }")
    q.execute([{:foo  => 1},{:foo  => 2}, {:foo => 60}]).must_equal(63)

    q = Dredd::Query.new("all.mean{ foo }")
    q.execute([{:foo  => 0},{:foo  => 0}, {:foo => 60}]).must_equal(20)
  end

  it "should run aggregations without projection" do
    q = Dredd::Query.new("all{ foo > 10 }.size")
    q.execute([{:foo  => 1},{:foo  => 2}, {:foo => 60}]).must_equal(1)

    q = Dredd::Query.new("(all{ foo > 10 }.size.is 0)")
    q.execute([{:foo  => 1},{:foo  => 2}, {:foo => 60}]).must_equal(false)
  end

  it "should run aggregations on queries" do
    q = Dredd::Query.new("all{ foo > 10 }.sum{ foo }")
    q.execute([{:foo  => 1},{:foo  => 2}, {:foo => 60}]).must_equal(60)

    q = Dredd::Query.new("all{ foo > 10 }.mean{ foo }")
    q.execute([{:foo  => 0},{:foo  => 0}, {:foo => 60}]).must_equal(60)

    q = Dredd::Query.new("all{ foo > 10 }.size{ foo }")
    q.execute([{:foo  => 0},{:foo  => 0}, {:foo => 60}]).must_equal(1)

    q = Dredd::Query.new("all{ foo > 10 }.min{ foo }")
    q.execute([{:foo  => 0},{:foo  => 0}, {:foo => 60}]).must_equal(60)

    q = Dredd::Query.new("all{ foo > 10 }.max{ foo }")
    q.execute([{:foo  => 0},{:foo  => 0}, {:foo => 60}]).must_equal(60)
  end

  it "should run aggregations on empty queries" do
    q = Dredd::Query.new("all{ foo > 100 }.sum{ foo }")
    q.execute([{:foo  => 1},{:foo  => 2}, {:foo => 60}]).must_equal(0)

    q = Dredd::Query.new("all{ foo > 100 }.mean{ foo }")
    q.execute([{:foo  => 1},{:foo  => 2}, {:foo => 60}]).nan?.must_equal true
  end
end
