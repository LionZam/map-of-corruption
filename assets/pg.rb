require 'rubygems'
require 'bundler'
require 'pg'

class DBInit
  def self.conn
    @conn = PG.connect :dbname => 'd3ohjsau9r90oa', :user => 'ugkklpslfcqkvo', :password => 'de8d2d24dab72b0ab2e9c38edff53ad3d4197ca5fd675f7a59da21388b08e8cb', :host => 'ec2-46-137-75-170.eu-west-1.compute.amazonaws.com', :port => '5432'
  rescue PG::ConnectionBad
    puts "Sorry, database not exist!"
  end
end