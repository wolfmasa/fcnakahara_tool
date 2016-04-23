require 'open-uri'
require 'json'

url = 'https://spreadsheets.google.com/feeds/cells/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y/od6/public/values?alt=json'

def open_doc url
  f = open(url)
  buff = JSON.parse(f.read)
  f.close
  buff
end

def parse_doc_json buff
  entry = buff["feed"]["entry"]

  list = []
  entry.each do |e|
    cell = e["gs$cell"]
    row = cell["row"].to_i
    col = cell["col"].to_i
    text = cell["$t"]

    list[row] = [] if list[row].nil?
    list[row] << {row: row, col: col, text: text}

  end
  list
end

def get_schedule_list list
  list.select! do |l|
    (! l.nil?) and
      (!l.first.nil?) and
      (/^\d{2}\(/ === l.first[:text])
  end

  schedule = []
  list.each do |l|
    (TARGET_COL).downto(3) do |i|
      result = l.find { |item| item[:col] == i}
      if result
        schedule << {date: l.first[:text], text: result[:text]}
        break
      end
    end
  end
  schedule
end



buff = open_doc url
contents_list = parse_doc_json buff


TARGET_COL = 5
schedule = get_schedule_list contents_list

require 'pp'
pp schedule

client_id = '485972520424-hfudjgnu1qb3vv09e4u0h82tq45d1oqp.apps.googleusercontent.com'
