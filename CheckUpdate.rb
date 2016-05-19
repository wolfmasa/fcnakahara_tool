#require './CalendarManager.rb'
require './ScheduleManager.rb'
require './ParseScheduleUrl.rb'
#require './EventCompare'
require 'pp'

Debug = true

class CheckUpdate

  def self.getGDocUrls
    @gdoc_urls = ParseScheduleUrl.getUrlList
    pp @gdoc_urls if Debug
  end

  def self.getEventsFromMasterCalendar url=nil
    @master = ScheduleManager.new
    events = @master.getEvents
    pp events if Debug
    events
  end
end


p ParseScheduleUrl.getDateList
