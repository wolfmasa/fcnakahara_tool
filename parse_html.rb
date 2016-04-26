require 'open-uri'
require 'pp'

url = 'http://fcnakahara.nobody.jp'
reg = %r!https://docs.google.com/spreadsheets/d/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y[^\"]+!

target_url = []
open(url) do |f|
  target_url = f.read.scan(reg).select do |item|
    ! item[/output=pdf/]
  end
end

p target_url



