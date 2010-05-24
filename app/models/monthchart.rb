class Monthchart
  attr_accessor :users, :month, :year
  attr_accessor :time_entries

  attr_accessor :sort

  def initialize(options = { })
   self.time_entries = { }
   self.users = User.find(:all).collect(&:id)
   self.month = options[:month] || Date.today.month.to_s
   self.year = options[:year] || Date.today.year.to_s
  end
  
   def conditions(users)
      if self.month && self.year
        conditions = ['tmonth = (?) AND tyear = (?) AND user_id = (?)',
                      self.month, self.year,users]
     end
    Redmine::Hook.call_hook(:plugin_timesheet_model_timesheet_conditions, { :timesheet => self, :conditions => conditions})
    return conditions
  end
   
  def fetch_time_entries_by_user(curr_user)
  
    self.users.each do |user_id|
      logs = []
      if User.current.admin?
        if curr_user
	  if curr_user==user_id
	    logs = time_entries_for_user(user_id)
	  end
	else
	  if User.current.id == user_id
	    logs = time_entries_for_user(user_id)
	  end
	end
      else
        if User.current.id == user_id
	    logs = time_entries_for_user(user_id)
	end
      end 
    
      unless logs.empty?
        user = User.find_by_id(user_id)
        self.time_entries[user.name] = { :logs => logs }  unless user.nil?
      end
    end
  end
  
   def time_entries_for_user(user)
    return TimeEntry.find(:all,
                          :conditions => self.conditions([user]),
                          :include => [:activity, :user, {:issue => [:tracker, :assigned_to, :priority]}],
                          :order => "spent_on ASC"
                          )
  end
end