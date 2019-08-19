require './config/environment'
require './lib/cli'

# binding.pry
cli = CommandLineInterface.new
cli.main_menu