#!/usr/bin/ruby
require 'pdf-reader'

REGEX = /\A\d+\z/

def main()
	datos = Array.new
	reader = PDF::Reader.new('1.pdf')	
	reader.pages.each do |page|
	  datos.push  page.text
	end
	return datos
end

def procedimiento(datos)

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
end


def indicador(datos)
	indicador = Array.new
	indicador.push datos[0].split(/\n/)[12].slice(110..-1)
	indicador.push datos[0].split(/\n/)[13].slice(110..-1)


	indicador.join(",").gsub(","," ").strip.gsub(/\s+/, " ")

	p indicador
end

datos = main
procedimiento datos
indicador datos