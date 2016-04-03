# AssertDirsEqual

[![Build Status](https://img.shields.io/travis/torba-rb/assert_dirs_equal.svg)](https://travis-ci.org/torba-rb/assert_dirs_equal)
[![Gem version](https://img.shields.io/gem/v/assert_dirs_equal.svg)](https://rubygems.org/gems/assert_dirs_equal)

**AssertDirsEqual** is a test framework-agnostic expectation/assertion for directories equality
by tree and content comparison.

## Status

Production ready.

## Documentation

[Released version](http://rubydoc.info/gems/assert_dirs_equal/0.2.0)

## Why

Sometimes it is easier to commit expected directory structure and compare it with a directory
created by a method under test.

If you prefer DSL-like expectations, see [minitest-filesystem][minitest-filesystem].

## Installation

Add this line to your application's Gemfile and run `bundle`:

```ruby
gem 'assert_dirs_equal', require: false
```
## Usage

```ruby
class MyWriter
  def self.perform
    File.write("/tmp/my_writer/result.txt", "Hello world!")
  end
end

```

Create a file "result.txt" with "Hello world!" in "test/fixtures/case01".

### Minitest

```ruby
require 'minitest/assert_dirs_equal'

class MyWriterTest < Minitest::Test
  def test_perform
    MyWriter.perform
    assert_dirs_equal "test/fixtures/case01", "/tmp/my_writer"
  end
end
```

### RSpec

TODO

## Known issues

Due that Rubinius String#strip doesn't fail on binary data (undocumented behaviour), the library will
try to actually diff binary files. Depending on your test framework's diffing tool, it may or may not
be a problem. For example, Minitest is not affected, since it uses shell `diff` under the hood.

## Origin

Extracted from [Torba][torba-github] library since it looks more like a standalone component.

[minitest-filesystem]: https://github.com/stefanozanella/minitest-filesystem
[torba-github]: https://github.com/torba-rb/torba
