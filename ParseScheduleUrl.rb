require 'open-uri'

class ParseScheduleUrl
  TopPage = 'http://fcnakahara.nobody.jp'
  GDocReg = %r!https://docs.google.com/spreadsheets/d/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y[^\"]+!

  def self.getUrlList
    target_url = []
    open(TopPage, "r:sjis") do |f|
      target_url = f.read.scan(GDocReg).select do |item|
        ! item[/output=pdf/]
      end
    end
    target_url
  end

  def self.getDateList
    target_url = []
    open(TopPage, "r:sjis") do |f|
      buff = f.read.encode('utf-8')
      target_url = buff.scan(/(\d{4})年(\d{2})月：/)
    end

    target_url
  end

  def self.getCalendarInfo url

    %r!/d/([\w\d_-]+)/! =~ url
    cid = $1

    %r!gid=(\d+)! =~ url
    gid = $1

    return cid, gid
  end

  def self.getGDocUrl cid, gid
    "https://spreadsheets.google.com/feeds/cells/#{cid}/#{gid}/public/values?alt=json"
  end

  def self.getGDoc base_url
    getGDocUrl(* getCalendarInfo( base_url ))
  end
def self.wid_to_gid(wid)
    wid_val = wid.length > 3 ? wid[1..-1] : wid
    xorval = wid.length > 3 ? 474 : 31578
    wid_val.to_i(36) ^ xorval
end

end


if $0 == __FILE__
  require 'pp'

  ParseScheduleUrl.getUrlList.each do |url|
    p url
    p ParseScheduleUrl.getGDoc url
    cid, gid = ParseScheduleUrl.getCalendarInfo url
    p ParseScheduleUrl.wid_to_gid cid
  end

end
