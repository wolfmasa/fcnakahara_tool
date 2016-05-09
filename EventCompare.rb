class Event
  attr_accessor: date, start_time, end_time, title, location
  def initialize date, start_time, end_time, title, location
    @date = date
    @start_time = start_time
    @end_time = end_time
    @title = title
    @location = location
  end

  def <=> dst
    @date <=> dst.date
  end
end

class EventCompare
  attr_accessor: equal, updated, added, deleted

  def initialize master, target
    @master = master
    @target = target
    raise "Master is not kind of Array" unless @master.kind_of? Array
    raise "Target is not kind of Array" unless @target.kind_of? Array

    @equal, @updated, @added, @deleted = [], [], [], []
  end

  def compare
    me = @master.dup.sort
    te = @target.dup.sort

    me.each do |m|
      same_date = te.find {|t| t.date == m.date}
      if same_date.count == 0
        @added << m
      elsif same_date == 1
        if same_date.first == m
          @equal << m
        else
          @updated << {master: m, target: same_date.first}          
        end
        te.delete same_date.first
      else
        # Hit several events with same date
      end
    end
    @deleted << * te
  end
end
