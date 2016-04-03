require "minitest"
require "assert_dirs_equal/matcher"

module AssertDirsEqual
  class Diff
    extend Minitest::Assertions

    def self.perform(expected, actual)
      diff(expected, actual)
    end
  end
end

class Minitest::Test
  def assert_dirs_equal(expected, target)
    matcher = AssertDirsEqual::Matcher.new(expected)
    assert matcher.matches?(target), matcher.failure_message
  end

  def refute_dirs_equal(expected, target)
    matcher = AssertDirsEqual::Matcher.new(expected)
    refute matcher.matches?(target), matcher.failure_message_when_negated
  end

  def assert_dir_included(expected, target)
    matcher = AssertDirsEqual::Matcher.new(expected, exact_match: false)
    assert matcher.matches?(target), matcher.failure_message
  end

  def refute_dir_included(expected, target)
    matcher = AssertDirsEqual::Matcher.new(expected, exact_match: false)
    refute matcher.matches?(target), matcher.failure_message_when_negated
  end
end
