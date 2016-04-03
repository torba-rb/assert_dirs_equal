require "test_helper"
require "assert_dirs_equal/matcher"

module AssertDirsEqual
  class MatcherEqTest < Minitest::Test
    def matcher
      @matcher ||= Matcher.new(expected_dir)
    end

    def test_missing_expected
      @case_directory = "test/cases/missing_expected"
      refute matcher.matches?(target_dir)
      assert_equal "expected \"#{expected_dir}\" to exist", matcher.failure_message
    end

    def test_missing_target
      @case_directory = "test/cases/missing_target"
      refute matcher.matches?(target_dir)
      assert_equal "expected \"#{target_dir}\" to exist", matcher.failure_message
    end

    def test_expected_is_not_a_dir
      @case_directory = "test/cases/expected_is_not_a_dir"
      refute matcher.matches?(target_dir)
      assert_equal "expected \"#{expected_dir}\" to be a directory", matcher.failure_message
    end

    def test_target_is_not_a_dir
      @case_directory = "test/cases/target_is_not_a_dir"
      refute matcher.matches?(target_dir)
      assert_equal "expected \"#{target_dir}\" to be a directory", matcher.failure_message
    end

    def test_missing_file_in_target
      @case_directory = "test/cases/missing_file_in_target"
      refute matcher.matches?(target_dir)
      assert_equal "expected \"#{target_dir}/file\" to exist since \"#{expected_dir}/file\" exists", matcher.failure_message
    end

    def test_missing_nested_file_in_target
      @case_directory = "test/cases/missing_nested_file_in_target"
      refute matcher.matches?(target_dir)
      assert_equal "expected \"#{target_dir}/nested/file\" to exist since \"#{expected_dir}/nested/file\" exists", matcher.failure_message
    end

    def test_empty_files_are_equal
      @case_directory = "test/cases/empty_files_are_equal"
      assert matcher.matches?(target_dir), matcher.failure_message
    end

    def test_different_text_files
      @case_directory = "test/cases/different_text_files"
      refute matcher.matches?(target_dir)
      assert_equal <<MSG.strip, matcher.failure_message
expected "#{target_dir}/file" to have same content as "#{expected_dir}/file":
Expected: "hello"
  Actual: "world"
MSG
    end

    def test_same_text_files
      @case_directory = "test/cases/same_text_files"
      assert matcher.matches?(target_dir), matcher.failure_message
    end

    def test_same_text_files_with_trailing_newline
      @case_directory = "test/cases/same_text_files_with_trailing_newline"
      assert matcher.matches?(target_dir), matcher.failure_message
    end

    def test_different_binary_files
      skip_rubinius_string_strip
      @case_directory = "test/cases/different_binary_files"
      refute matcher.matches?(target_dir)
      assert_equal "expected \"#{target_dir}/file.png\" to be the same as \"#{expected_dir}/file.png\"", matcher.failure_message
    end

    def test_same_binary_files
      skip_rubinius_string_strip
      @case_directory = "test/cases/same_binary_files"
      assert matcher.matches?(target_dir), matcher.failure_message
    end

    def test_binary_and_text_files
      skip_rubinius_string_strip
      @case_directory = "test/cases/binary_and_text_files"
      refute matcher.matches?(target_dir)
      assert_equal "expected \"#{target_dir}/file.txt\" to be the same as \"#{expected_dir}/file.txt\"", matcher.failure_message
    end

    def test_extra_file_in_target
      @case_directory = "test/cases/extra_file_in_target"
      refute matcher.matches?(target_dir)
      assert_equal "found unexpected files [\"#{target_dir}/file\"]", matcher.failure_message
    end

    def test_failure_message_negated
      @case_directory = "test/cases/empty_dirs_are_equal"
      matcher.matches?(target_dir)
      assert_equal "expected \"#{target_dir}\" to not be equal to \"#{expected_dir}\", but they are equal", matcher.failure_message_when_negated
    end
  end

  class MatcherIncludesTest < MatcherEqTest
    def matcher
      @matcher ||= Matcher.new(expected_dir, exact_match: false)
    end

    def test_extra_file_in_target
      @case_directory = "test/cases/extra_file_in_target"
      assert matcher.matches?(target_dir), matcher.failure_message
    end

    def test_failure_message_negated
      @case_directory = "test/cases/empty_dirs_are_equal"
      matcher.matches?(target_dir)
      assert_equal "expected files from \"#{target_dir}\" to not be present in \"#{expected_dir}\", but they are", matcher.failure_message_when_negated
    end
  end
end
