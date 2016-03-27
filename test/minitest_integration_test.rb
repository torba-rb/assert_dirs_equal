require "test_helper"
require "minitest/assert_dirs_equal"

module AssertDirsEqual
  class MinitestIntegrationTest < Minitest::Test
    def test_successful_assert
      @case_directory = "test/cases/empty_files_are_equal"
      assert_dirs_equal expected_dir, target_dir
    end

    def test_failed_assert
      @case_directory = "test/cases/missing_expected"

      error = assert_raises(Minitest::Assertion) do
        assert_dirs_equal expected_dir, target_dir
      end

      assert_equal "expected \"#{expected_dir}\" to exist", error.message
    end

    def test_successful_refute
      @case_directory = "test/cases/missing_expected"
      refute_dirs_equal expected_dir, target_dir
    end

    def test_failed_refute
      @case_directory = "test/cases/empty_files_are_equal"

      error = assert_raises(Minitest::Assertion) do
        refute_dirs_equal expected_dir, target_dir
      end

      assert_equal "expected \"#{target_dir}\" to not be equal to \"#{expected_dir}\", but they are equal", error.message
    end

    def test_minitest_powered_diff
      @case_directory = "test/cases/large_different_text_files"

      error = assert_raises(Minitest::Assertion) do
        assert_dirs_equal expected_dir, target_dir
      end

      assert_equal <<MSG, error.message
expected "#{target_dir}/file" to have same content as "#{expected_dir}/file":
--- expected
+++ actual
@@ -11,7 +11,7 @@
 minitest
 minitest
 minitest
-minitest
+rspec
 minitest
 minitest
 minitest
MSG
    end
  end
end
