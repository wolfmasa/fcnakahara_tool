#require './CalendarManager.rb'
require './ScheduleManager.rb'
require './ParseScheduleUrl.rb'
#require './EventCompare'
require 'pp'

Debug = true

class CheckUpdate

  def self.getGDocUrlInfo
    @gdoc_urls = ParseScheduleUrl.getUrlList
    @gdoc_dates = ParseScheduleUrl.getDateList
    pp @gdoc_urls if Debug
    pp @gdoc_dates if Debug
  end

  def self.getEventsFromMasterCalendar url=nil
    @master = ScheduleManager.new
    events = @master.getEvents
    pp events if Debug
    events
  end
end

