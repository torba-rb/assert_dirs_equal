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
  # Fails if `target` lacks some files, or has extra files, or any file in the directory differs
  # from according content in `expected`.
  #
  # @param [String] expected path to a directory which contains expected structure and content.
  # @param [String] target path to a directory which contains result of executing a method under test.
  # @raise [Minitest::Assertion]
  # @since 0.1.0
  def assert_dirs_equal(expected, target)
    matcher = AssertDirsEqual::Matcher.new(expected)
    assert matcher.matches?(target), matcher.failure_message
  end

  # Fails if `target` has exactly the same file tree structure and content.
  #
  # @param (see #assert_dirs_equal)
  # @raise [Minitest::Assertion]
  # @since 0.1.0
  def refute_dirs_equal(expected, target)
    matcher = AssertDirsEqual::Matcher.new(expected)
    refute matcher.matches?(target), matcher.failure_message_when_negated
  end

  # Fails if `target` lacks some files, or any file in the directory differs from according content
  # in `expected`. Should be read as 'Content from `expected` is expected to be "included" in `target`'.
  # @note Extra files in `target` are ignored.
  #
  # @param (see #assert_dirs_equal)
  # @raise [Minitest::Assertion]
  # @since 0.2.0
  def assert_dir_included(expected, target)
    matcher = AssertDirsEqual::Matcher.new(expected, exact_match: false)
    assert matcher.matches?(target), matcher.failure_message
  end

  # Fails if `target` includes the same files from `expected`.
  # @note Extra files in `target` are ignored.
  #
  # @param (see #assert_dirs_equal)
  # @since 0.2.0
  def refute_dir_included(expected, target)
    matcher = AssertDirsEqual::Matcher.new(expected, exact_match: false)
    refute matcher.matches?(target), matcher.failure_message_when_negated
  end
end
