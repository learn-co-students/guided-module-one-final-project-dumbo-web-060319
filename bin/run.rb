require_relative "../config/environment"
require_relative "./user_interface.rb"
ActiveRecord::Base.logger = nil

cli = CLI.new
cli.welcome_menu
