require 'open-uri'
require 'json'
require 'date'

class ParseGoogleDoc

  Month = 4
  Cid = '1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y'
  Wid = 'od6'
  #wid = '1434845912'
  GDocUrl = "https://spreadsheets.google.com/feeds/cells/#{Cid}/#{Wid}/public/values?alt=json"

=begin
https://docs.google.com/spreadsheets/d/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y/pubhtml?gid=0&single=true
https://docs.google.com/spreadsheets/d/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y/pubhtml?gid=1434845912&single=true
https://spreadsheets.google.com/feeds/worksheets/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y/public/basic
=end


  TARGET_COL = 5
  @@debug = true

  def initialize url=nil
    puts url if @@debug
    @url = url || GDocUrl
    @buff = nil
    open(@url) do |f|
      @buff = JSON.parse(f.read)
    end
    parseGDoc
  end

  def parseGDoc
    entry = @buff["feed"]["entry"]

    @list = []
    entry.each do |e|
      cell = e["gs$cell"]
      row = cell["row"].to_i
      col = cell["col"].to_i
      text = cell["$t"]

      @list[row] = [] if @list[row].nil?
      @list[row] << {row: row, col: col, text: text}

    end
    puts @list if @@debug
    @list
  end

  def getEvents month = Month
    @list.select! do |l|
      (! l.nil?) and
        (!l.first.nil?) and
        (/^\d{2}\(/ === l.first[:text])
    end

    schedule = []
    @list.each do |l|
      (TARGET_COL).downto(3) do |i|
        result = l.find { |item| item[:col] == i}
        if result

          d = Date.new(2016, month, l.first[:text][/^\d{2}/].to_i)
          context = result[:text]
          puts context if @@debug

          m = context.match(/^(\d+:\d+).(\d+:\d+)?\n?\s?(\D+)$/)
          puts m if @@debug
          start_time, end_time = m[1], m[2]

          #schedule << {date: l.first[:text], text: result[:text]}
          schedule << {date: d, start_time: start_time, end_time: end_time,
                       context: m[3], original: result[:text]}
          break
        end
      end
    end
    puts schedule if @@debug
    schedule
  end

end

if $0 == __FILE__

  pgd = ParseGoogleDoc.new
  events = pgd.getEvents

  require 'pp'
  pp events

  client_id = '485972520424-hfudjgnu1qb3vv09e4u0h82tq45d1oqp.apps.googleusercontent.com'
end
