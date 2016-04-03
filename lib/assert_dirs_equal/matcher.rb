# @since 0.1.0
module AssertDirsEqual
  class Diff
    # @return [String] human readable diff between `expected` and `actual`.
    # @abstract Reuse existing test framework diff functionality to override this method.
    def self.perform(expected, actual)
      "Expected: #{expected.inspect}\n  Actual: #{actual.inspect}"
    end
  end

  # Confirms with RSpec3 custom matcher protocol.
  # @see https://github.com/rspec/rspec-expectations/blob/3-0-maintenance/lib/rspec/matchers.rb#L130
  class Matcher
    # @return [String]
    attr_reader :failure_message

    # @param [String] expected path to a directory which contains expected structure and content.
    # @param [Hash] options
    # @option options [Boolean] exact_match (true) specifies whether `expected` should mirror `target`,
    #   or just be a subset of it.
    def initialize(expected, options = {})
      @expected = expected
      @exact_match = options.fetch(:exact_match, true)
    end

    # @param [String] target path to a directory which contains result of executing a method under test.
    # @return [true] when `exact_match` is true and `target` mirrors `expected` directory.
    # @return [true] when `exact_match` is false and `target` contains all files from `expected` directory.
    #   Extra files in `target` does not affect the result.
    # @return [false] if `target` lacks some files, or has extra files (when `exact_match` is true), or any
    #   file in subdirectory differs from according file content.
    def matches?(target)
      @target = target
      assert_exists(@expected) && assert_exists(@target) &&
        assert_directory(@expected) && assert_directory(@target) &&
        assert_target_contains_all_expected_entries &&
        refute_extra_files_in_target
    end

    # @!attribute [r]
    # @return [String]
    def failure_message_when_negated
      if @exact_match
        "expected #{@target.inspect} to not be equal to #{@expected.inspect}, but they are equal"
      else
        "expected files from #{@target.inspect} to not be present in #{@expected.inspect}, but they are"
      end
    end

    private

    def assert_exists(path, msg = nil)
      File.exist?(path) || fail_with(msg || "expected #{path.inspect} to exist")
    end

    def assert_directory(directory)
      File.directory?(directory) || fail_with("expected #{directory.inspect} to be a directory")
    end

    def assert_equal_content(expected, target)
      return true if File.directory?(expected) && File.directory?(target)

      expected_content = File.read(expected)
      target_content = File.read(target)

      expected_content = expected_content.strip
      target_content = target_content.strip

      expected_content == target_content || fail_with(
        "expected #{target.inspect} to have same content as #{expected.inspect}:\n#{Diff.perform(expected_content, target_content)}"
      )
    rescue ArgumentError # strip on binary file
      expected_content == target_content || fail_with(
        "expected #{target.inspect} to be the same as #{expected.inspect}"
      )
    end

    def assert_target_contains_all_expected_entries
      both_paths_in(@expected, @target).all? do |expected_path, target_path|
        exists_msg = "expected #{target_path.inspect} to exist since #{expected_path.inspect} exists"
        assert_exists(target_path, exists_msg) && assert_equal_content(expected_path, target_path)
      end
    end

    def refute_extra_files_in_target
      return true unless @exact_match

      expected_files = both_paths_in(@expected, @target).map { |pair| pair[1] }
      actual_expected_files = Dir.glob(File.join(@target, "**/*"))
      diff = actual_expected_files - expected_files
      diff.empty? || fail_with("found unexpected files #{diff.inspect}")
    end

    def fail_with(message)
      @failure_message = message
      false
    end

    def both_paths_in(expected, target)
      Enumerator.new do |y|
        glob = File.join(expected, "**/*")
        Dir.glob(glob).each do |expected_full_path|
          path = expected_full_path.sub(expected, "")
          target_full_path = File.join(target, path)
          y << [expected_full_path, target_full_path]
        end
      end
    end
  end
end

