#require File.expand_path('CalendarManager.rb', File.dirname(__FILE__))
require './ScheduleManager.rb'
require './ParseScheduleUrl.rb'
require './EventCompare'
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
    events
  end
end

if $0 == __FILE__
  ss = SyncSchedule.new
  master_list = []
  ss.getGDocUrls.each do |u|
    events = ss.getEventsFromMasterCalendar u
    events.each do |e|
      master_list << Event.new(e[:date], e[:start_time], e[:end_time], e[:context], e[:location])
    end
  end
  pp master_list
end
