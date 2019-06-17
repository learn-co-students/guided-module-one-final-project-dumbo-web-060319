require_relative 'config/environment'
require_relative 'models/pokeball.rb'
require_relative 'models/pokemon.rb'
require_relative 'models/team.rb'
require_relative 'models/user.rb'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  Pry.start
end

desc "Rewrites _pokedex.json as pokedex.json "
task :format_json do
	JsonFormatter.new
end
