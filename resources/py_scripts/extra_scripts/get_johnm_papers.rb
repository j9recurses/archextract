S#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'


#grab the list of documents off the website
doc = Nokogiri::HTML(open('https://gist.githubusercontent.com/tingletech/181482a3edad39dded2e/raw/14db0003a9debae9faed831ce82e8255cf1f736c/muir_mets.txt'))


#parse the html
letterlist = ''
node = doc.xpath('//p')
cool = Array.new()
node.each do | n|
  stuff = n.text
  letterlist = stuff.split("\n")
end

#make a text file of the list all files
open("../data/list_of_john_muir_papers.txt", "wb") do |file|
  letterlist.each do | n|
    file.write(n)
  end
end

##now, grab the mets object from each webpage
letterlist.each do | n|
  puts n
  name = n.split("/")
  doc = Nokogiri::XML(open(n))
  #write the original xml to a file
  open("../data/xml/john_muir_papers_xml_s" + name[-1] + ".xml", "wb") do |file|
    file.write(doc)
  end
  #now parse the xml to get the text --> #<mets:fileGrp USE="transcription">
  plain_text = doc.xpath("//mets:fileGrp")
  plain_text.each do | p |
    s =  p.children()
    s2 = s.children()
    s3 = s2.children()
    s4 = s3.children()
    s4.each do | s |
      ##grab the plain text from the mets
      letter_text = s.xpath("//transcription")
      #convert it to html to preserve line breaks- need to do this for topic document browser
      letter_text = letter_text.to_html()
      #letter_text = .gsub("<br>","<\br>")
      letter_text_doc = Nokogiri::HTML(letter_text)
      letter_text_doc.search('br').each do |n|
        n.replace("\n")
      end
      letter_text = letter_text_doc.text
      open("../data/plaintxt2/john_muir_papers_txt_" + name[-1] + ".txt", "w:UTF-8") do |file|
        file.write(name[-1] + "\n\n")
        file.write(letter_text)
      end
    end
  end
end
