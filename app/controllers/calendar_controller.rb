
require 'ruby-debug'

class CalendarController < ApplicationController
  unloadable
  layout 'base'
  def index
    calendar
  end
  
  def calendar
    if params[:year] and params[:year].to_i > 1900
      @year = params[:year].to_i
      if params[:month] and params[:month].to_i > 0 and params[:month].to_i < 13
        @month = params[:month].to_i
      end    
    end
    @year ||= Date.today.year
    @month ||= Date.today.month
    @calendar = Redmine::Helpers::Calendar.new(Date.civil(@year, @month, 1), current_language, :month)
    
    if params[:userhours]
     @userid = params[:userhours]
    end
    if @userid 
      @userid = @userid.to_i
    end
    @timesheet = Monthchart.new({:month=>@month, :year=>@year})
    @timesheet.fetch_time_entries_by_user(@userid)
     # Sums
    
    @total = 0
    @dayhours = {}
    unless @timesheet.sort == :issue
      @timesheet.time_entries.each do |project,logs|
        @total = 0
	#debugger
        if logs[:logs]
          logs[:logs].each do |log|
            @total += log.hours
	    if  @dayhours[log.spent_on.day].nil?
	      @dayhours[log.spent_on.day] = 0
	    end
	    @dayhours[log.spent_on.day] += log.hours
          end
        end
      end
    else
      @timesheet.time_entries.each do |project, project_data|
        @total = 0
        if project_data[:issues]
        project_data[:issues].each do |issue, issue_data|
            @total += issue_data.collect(&:hours).sum
          end
        end
      end
    end
    render :layout => false if request.xhr?
  end
  
  def dayschedule
    if params[:year] and params[:year].to_i > 1900
      @year = params[:year].to_i
      if params[:month] and params[:month].to_i > 0 and params[:month].to_i < 13
        @month = params[:month].to_i
      end    
    end
    if params[:day] and params[:day].to_i > 0 and params[:day].to_i < 32
        @day = params[:day].to_i
    end
    @year ||= Date.today.year
    @month ||= Date.today.month
    @day ||= Date.today.day
    
    #debugger
    @timesheet = Monthchart.new({:month=>@month, :year=>@year})
    @timesheet.fetch_time_entries_by_user(@userid)
     # Sums
 #    debugger
    @total = []
 #   @dayhours = 0
    unless @timesheet.sort == :issue
      @timesheet.time_entries.each do |project,logs|
#        @total = 0
        if logs[:logs]
          logs[:logs].each do |log|
           # @total += log.hours
	   #debugger
	    if (log.spent_on.day == @day)
	      @total << log
	    end
	    #if  @dayhours[log.spent_on.day].nil?
	    #  @dayhours[log.spent_on.day] = 0
	    #end
	    #@dayhours[log.spent_on.day] += log.hours
          end
        end
      end
      #debugger
    else
     # @timesheet.time_entries.each do |project, project_data|
     #   @total = 0
     #   if project_data[:issues]
     #   project_data[:issues].each do |issue, issue_data|
     #      # @total += issue_data.collect(&:hours).sum
     #     end
     #   end
     # end
     
    end
    
    render :layout => false if request.xhr?
  end
  
end
