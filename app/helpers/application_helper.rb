module ApplicationHelper
  def simple_time(time)
    #time.strftime("%Y-%m-%d　%H:%M　")
    str= "[" + time.strftime("%H:%M") + "]"
    return str
  end

  def simple_time2(time)
    time.strftime("%Y-%m-%d")
  end

  def simple_time3(time)
    time.strftime("%Y-%m-%d %H:%M")
  end

end
