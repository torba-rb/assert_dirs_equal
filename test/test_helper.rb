require "bundler/setup"
require "minitest/autorun"

class Minitest::Test
  def expected_dir
    File.join(@case_directory, "expected")
  end

  def target_dir
    File.join(@case_directory, "target")
  end
end
