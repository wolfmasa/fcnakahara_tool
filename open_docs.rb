require 'open-uri'
require 'json'
require 'date'

month = 4
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

def get_schedule_list list, month
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
        
        d = Date.new(2016, month, l.first[:text][/^\d{2}/].to_i)
        context = result[:text].split("\n")

        p context
        m = context.first.match(/^(\d+:\d+).(\d+:\d+)?$/)
        p m
        start_time, end_time = m[1], m[2]

        #schedule << {date: l.first[:text], text: result[:text]}
        schedule << {date: d, start_time: start_time, end_time: end_time,
                     context: context[1,]}
        break
      end
    end
  end
  schedule
end



buff = open_doc url
contents_list = parse_doc_json buff


TARGET_COL = 5
schedule = get_schedule_list contents_list, month

require 'pp'
pp schedule

