if $PROGRAM_NAME == __FILE__ && ARGV.first == "run"
  game = Game.new
  if ARGV.length > 1
    game.seed(ARGV[1])
  end
  game.run
elsif $PROGRAM_NAME == __FILE__ ||
  ($PROGRAM_NAME == __FILE__ && ARGV.first == "test")
  require "minitest/autorun"
end

# == References:
# - [typechecking \- Check if Ruby object is a Boolean \- Stack Overflow]
#   (https://stackoverflow.com/questions/3028243/check-if-ruby-object-is-a-boolean)
#
# - [Ruby Language: Simple Flip\-a\-coin Application]
#   (http://rubylanguage.blogspot.com.au/2012/08/simple-flip-coin-application.html)
#

# >> Run options: --seed 53645
# >>
# >> # Running:
# >>
# >> ......................
# >>
# >> Finished in 0.033987s, 647.3063 runs/s, 1529.9968 assertions/s.
# >>
# >> 22 runs, 52 assertions, 0 failures, 0 errors, 0 skips
