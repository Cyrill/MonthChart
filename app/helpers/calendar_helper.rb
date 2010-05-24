module CalendarHelper

  def renderHours(day,month,value)
    value||=0
    content=''
    style=''
    content << "<div class=\"daytime "
    content << "\">"
    if (value > 10)
      style << "warn"
    elsif (value >= 8)
      style << "more"
    else
      if (day.wday==0||day.wday==6)
        style << "more"
      else
        style << "less"
      end
    end
   # content << "\">"
    if (day.month==month)
      unless (day.wday==0||day.wday==6) && value == 0
	#content << (link_to value.to_s, {:controller => 'calendar', :action =>'dayschedule', :year=>day.year, :month=>month,:day=>day.day}, {:class =>'daylink '+ style}) 
        content << "<div class=\"" + style + "\">"
	content << value.to_s    
	content << "</div>"
      end
    end
    content << "</div>"
  end
  
end
