require 'open-uri'
require 'json'
require 'date'

month = 4
cid = '1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y'
wid = 'od6'
#wid = '1434845912'
url = "https://spreadsheets.google.com/feeds/cells/#{cid}/#{wid}/public/values?alt=json"

=begin
https://docs.google.com/spreadsheets/d/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y/pubhtml?gid=0&single=true
https://docs.google.com/spreadsheets/d/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y/pubhtml?gid=1434845912&single=true
https://spreadsheets.google.com/feeds/worksheets/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y/public/basic
=end

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
        context = result[:text]
        p context

        m = context.match(/^(\d+:\d+).(\d+:\d+)?\n?\s?(\D+)$/)
        p m
        start_time, end_time = m[1], m[2]

        #schedule << {date: l.first[:text], text: result[:text]}
        schedule << {date: d, start_time: start_time, end_time: end_time,
                     context: m[3], original: result[:text]}
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

client_id = '485972520424-hfudjgnu1qb3vv09e4u0h82tq45d1oqp.apps.googleusercontent.com'
