#!/usr/bin/ruby
require 'pdf-reader'

reader = PDF::Reader.new('FormA0.pdf')

arreglo = Array.new
datos = Array.new

reader.pages.each do |page|
  datos.push  page.text
end

puts datos
