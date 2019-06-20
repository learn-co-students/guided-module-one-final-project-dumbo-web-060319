require "bundler/setup"
require 'yaml'
require 'active_record'
require 'tty-prompt'

Bundler.require

Dir[File.join(File.dirname(__FILE__), "../lib", "*.rb")].each {|f| require f}

DB = ActiveRecord::Base.establish_connection({
	adapter: 'sqlite3',
	database: 'db/pokemon_project.db'
})