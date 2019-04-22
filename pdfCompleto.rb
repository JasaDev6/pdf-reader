#!/usr/bin/ruby
require 'pdf-reader'
require 'pg'

require 'faker'
require 'date'

REGEX = /\A\d+\z/

mostrar = Array.new

	datos = Array.new
	reader = PDF::Reader.new('2.pdf')	
	reader.pages.each do |page|
	  datos.push  page.text
	end



	actividades = Array.new
	arreglo = Array.new

	for q in 0..datos.length-1
		arreglo = datos[q].split(/\n/)
		
		lineas = Array.new

		contador = 0
		tamanio = arreglo.length-1

		for i in 0..tamanio
			dato = arreglo[i].slice(0,1)  
			if REGEX.match dato then
				lineas.push i
				if i == tamanio then
					lineas.push i+1
				end	
			end

			ultimo= arreglo[i].size()
			if ultimo == 0 && lineas.length !=0 then
				ultimo2 = arreglo[i+1].size()
				if ultimo2 == 0 then 
					lineas.push i
					break
				end
			end

			if i == tamanio && lineas.length !=0 then
				diferencia = tamanio - lineas[-1]
				if diferencia < 3 then
					lineas.push i+1
				end
			end 

		end

		for j in 0..lineas.length-2
			actividad = Array.new
			fechaIni = Array.new
			fechaFin = Array.new
			evidencia = Array.new
			for k in lineas[j]-1..lineas[j+1]-1
				actividad.push arreglo[k].slice(0,37)
				fechaIni.push arreglo[k].slice(54,11)
				fechaFin.push arreglo[k].slice(65,11)
				evidencia.push arreglo[k].slice(87,21)
			end
			actividades.push actividad.join(",").gsub(","," ").strip.gsub(/\s+/, " ")
			actividades.push fechaFin.join(",").gsub(","," ").strip.gsub(/\s+/, " ")
			actividades.push fechaFin.join(",").gsub(","," ").strip.gsub(/\s+/, " ")
			actividades.push evidencia.join(",").gsub(","," ").strip.gsub(/\s+/, " ")
		end
	end
	puts actividades



	indicador = Array.new
	indicador.push datos[0].split(/\n/)[12].slice(110..-1)
	indicador.push datos[0].split(/\n/)[13].slice(110..-1)


	indicador.join(",").gsub(","," ").strip.gsub(/\s+/, " ")

 	p indicador


begin

    con = PG.connect :dbname => 'sistemapei', :user => 'antonio'
    
    con.exec "DROP TABLE IF EXISTS Actividad"
    con.exec "CREATE TABLE Actividad(Id INTEGER PRIMARY KEY, 
    	      Nombre VARCHAR(200), FechaIni DATE, FechaFin DATE, Evidencia VARCHAR(200))"

    for x in 0..actividades.length-1
    	Nombre = actividades[0]
    	FechaIni = actividades[1]
    	FechaFin = actividades[2]
    	Evidencia = actividades[3]
    	#con.exec "INSERT INTO Actividad VALUES('#{x}', '#{Nombre}', '#{FechaIni}', '#{FechaFin}', '#{Evidencia}')"
    end

        con.exec "INSERT INTO Actividad VALUES(0, '#{actividades[0]}', '#{actividades[1]}', '#{actividades[2]}', '#{actividades[3]}')"
    	con.exec "INSERT INTO Actividad VALUES(1, '#{actividades[4]}', '#{actividades[5]}', '#{actividades[6]}', '#{actividades[7]}')"
    	#con.exec "INSERT INTO Actividad VALUES(2, '#{actividades[8]}', '#{actividades[9]}', '#{actividades[10]}', '#{actividades[11]}')"
    	#con.exec "INSERT INTO Actividad VALUES(2, '#{actividades[12]}', '#{actividades[13]}', '#{actividades[14]}', '#{actividades[15]}')"


    con.exec "GRANT ALL PRIVILEGES ON TABLE Actividad TO antonio"

    
rescue PG::Error => e

    puts e.message 
    
ensure

    con.close if con
    
end


begin

    con = PG.connect :dbname => 'sistemapei', :user => 'antonio'
    
    con.exec "DROP TABLE IF EXISTS Indicador"
    con.exec "CREATE TABLE Indicador(Id INTEGER PRIMARY KEY, 
    	      Nombre VARCHAR(200))"

    for x in 0..indicador.length-1
    	Nombre = indicador[x]
    	con.exec "INSERT INTO Indicador VALUES('#{x}', '#{Nombre}')"
    end

    con.exec "GRANT ALL PRIVILEGES ON TABLE Indicador TO antonio"

    
rescue PG::Error => e

    puts e.message 
    
ensure

    con.close if con
    
end