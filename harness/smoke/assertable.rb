class Checker
  include Assertable

  def run
    assert(true, "should not raise")
    puts "assert true: ok"

    begin
      assert(false, "value was false")
    rescue Assertable::Assertion => e
      puts "assert false: #{e.message}"
    end

    assert_equal(42, 42)
    puts "assert_equal same: ok"

    begin
      assert_equal(1, 2, "numbers differ")
    rescue Assertable::Assertion => e
      puts "assert_equal diff: #{e.message}"
    end

    assert_includes([1, 2, 3], 2)
    puts "assert_includes found: ok"

    begin
      assert_includes([1, 2, 3], 9, "not there")
    rescue Assertable::Assertion => e
      puts "assert_includes missing: raised"
    end

    assert_nil(nil)
    puts "assert_nil nil: ok"

    begin
      assert_nil(42, "not nil")
    rescue Assertable::Assertion => e
      puts "assert_nil non-nil: raised"
    end

    refute(false, "should not raise")
    puts "refute false: ok"

    begin
      refute(true, "was true")
    rescue Assertable::Assertion => e
      puts "refute true: raised"
    end
  end
end

Checker.new.run
