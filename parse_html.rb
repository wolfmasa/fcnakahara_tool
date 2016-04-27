require 'open-uri'

class ParseGoogleDocUrl
  TopPage = 'http://fcnakahara.nobody.jp'
  GDocReg = %r!https://docs.google.com/spreadsheets/d/1aSE2HDWMOtGMKdvuplF8zaFIJYWWGgMJ-_qtZJG322Y[^\"]+!

  def self.getUrlList
    target_url = []
    open(TopPage) do |f|
      target_url = f.read.scan(GDocReg).select do |item|
        ! item[/output=pdf/]
      end
    end
    target_url
  end

end


if $0 == __FILE__
  require 'pp'
  pp ParseGoogleDocUrl.getUrlList
end
