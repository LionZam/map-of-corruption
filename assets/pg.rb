require 'rubygems'
require 'bundler'
require 'pg'

class DBInit
  def self.conn
    @conn = PG.connect :dbname => 'deputies', :user => 'deputy_user', :password => 'root'
  rescue PG::ConnectionBad
    puts "Sorry, database not exist!"
  end
end