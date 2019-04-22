#!/usr/bin/ruby
require 'pdf-reader'
require 'pg'

reader = PDF::Reader.new('1.pdf')

arreglo = Array.new
datos = Array.new

reader.pages.each do |page|
  datos.push  page.text
end

puts datos
puts 'Version of libpg: ' + PG.library_version.to_s

begin

    con = PG.connect :dbname => 'sistemapei', :user => 'antonio', 
        :password => 'antonio'

    user = con.user
    db_name = con.db
    pswd = con.pass
    
    puts "User: #{user}"
    puts "Database name: #{db_name}"
    puts "Password: #{pswd}" 
    
rescue PG::Error => e

    puts e.message 
    
ensure

    con.close if con
    
end


begin

    con = PG.connect :dbname => 'sistemapei', :user => 'antonio'
    
    con.exec "DROP TABLE IF EXISTS Cars"
    con.exec "CREATE TABLE Cars(Id INTEGER PRIMARY KEY, 
        Name VARCHAR(20), Price INT)"
    con.exec "INSERT INTO Cars VALUES(1,'Audi',52642)"
    con.exec "INSERT INTO Cars VALUES(2,'Mercedes',57127)"
    con.exec "INSERT INTO Cars VALUES(3,'Skoda',9000)"
    con.exec "INSERT INTO Cars VALUES(4,'Volvo',29000)"
    con.exec "INSERT INTO Cars VALUES(5,'Bentley',350000)"
    con.exec "INSERT INTO Cars VALUES(6,'Citroen',21000)"
    con.exec "INSERT INTO Cars VALUES(7,'Hummer',41400)"
    con.exec "INSERT INTO Cars VALUES(8,'Volkswagen',21600)"
    con.exec "GRANT ALL PRIVILEGES ON TABLE cars TO antonio"

    
rescue PG::Error => e

    puts e.message 
    
ensure

    con.close if con
    
end



