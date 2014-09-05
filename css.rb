#!/usr/bin/env ruby

require "rubygems"
require 'nokogiri'

#require "spidr"
#require "open-uri"

=begin
  = CSS snowball
  Rolls through your site, picking up style attributes and making you 
  a new stylesheet. Once you've got your stylesheet, run it through
  something like http://www.cleancss.com/ to clean it up.

  Outputs a CSS file and an instruction sheet.
=end

if ARGV.empty?
  puts "CSS-Snowball - rolls through your site picking up styles"
  puts "Usage: #{__FILE__} http://www.example > output.css"
  exit
end

xml_dir=File.dirname(__FILE__)
p=Nokogiri::XML(open("#{xml_dir}/#{ARGV[0]}"))
s=p.search('svg').first

at=[]
s.search('[style]').each do |n|
 at << n.attribute('style').value
end

ft=Nokogiri::XML::Node.new('feGaussianBlur',p)
ft['stdDeviation']="5"
fl=Nokogiri::XML::Node.new('filter',p)
fl['id']="pictureFilter"
fl.content=ft

n=1
al=""
sf=""
ac={}
at.uniq.each do |u|
 ac[u]="fenix#{n}"
 sf=".fenix#{n}:hover {filter: url(#pictureFilter);}"
 al=".fenix#{n} {#{u}}#{al}#{sf}"
 n+=1
end

st=Nokogiri::XML::Node.new('style',p)
st['type']="text/css"
st.content=al

s.search('[style]').each do |n|
 n['class']=ac[n.attribute('style').value]
 n.delete('style')
end

s.children.first.before(st)
s.add_child(fl)
puts s.to_html
