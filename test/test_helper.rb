require "bundler/setup"
require "minitest/autorun"

class Minitest::Test
  def expected_dir
    File.join(@case_directory, "expected")
  end

  def target_dir
    File.join(@case_directory, "target")
  end

  def skip_rubinius_string_strip
    if RUBY_ENGINE == "rbx"
      skip "Rubinius doesn't fail on binary data with String#strip"
    end
  end
end
