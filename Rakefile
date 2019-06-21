require_relative './config/environment.rb'
require 'sinatra/activerecord/rake'

require 'active_record'


desc "Start our app console"
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
#  ActiveRecord::Base.logger = nil
  Pry.start
end

desc "says 👋"
task :hello do
  puts "suppppp"
end
