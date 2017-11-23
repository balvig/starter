require "starter/version"
require "starter/main"

module Starter
  Main.new.run
rescue StandardError=> e
  puts e.message
end
