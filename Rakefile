require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  Pry.start
end

desc "Rewrites _pokedex.json as pokedex.json "
task :format_json do
	JsonFormatter.new
end
