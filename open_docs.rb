require 'open-uri'
require 'json'

google_document_url = 'https://spreadsheets.google.com/feeds/cells/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y/od6/public/values?alt=json'
key = '1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y'

f = open(google_document_url)
buff = JSON.parse(f.read)
f.close

entry = buff["feed"]["entry"]

list = []
entry.each do |e|
  cell = e["gs$cell"]
  row = cell["row"]
  col = cell["col"]
  text = cell["$t"]

  list << "#{row}, #{col} => #{text}"
end

p list
