$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "conway_game_of_life"

require "minitest/autorun"

def local_io(in_str = "")
  old_stdin = $stdin
  old_stdout = $stdout
  $stdin = StringIO.new(in_str)
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdin = old_stdin
  $stdout = old_stdout
end
