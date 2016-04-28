#require File.expand_path('CalendarManager.rb', File.dirname(__FILE__))
require File.expand_path('ScheduleManager.rb', File.dirname(__FILE__))
require File.expand_path('ParseScheduleUrl.rb', File.dirname(__FILE__))
require 'pp'

class SyncSchedule
  @@debug = true
  def initialize
  end

  def getGDocUrls
    @gdoc_urls = ParseScheduleUrl.getUrlList
    pp @gdoc_urls if @@debug
  end

  def getEventsFromMasterCalendar url=nil
    @master = ScheduleManager.new
    events = @master.getEvents
    pp events if @@debug
  end
end

if $0 == __FILE__
  ss = SyncSchedule.new
  ss.getGDocUrls.each do |u|
    ss.getEventsFromMasterCalendar u
  end
end
