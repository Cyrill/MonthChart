require 'redmine'

Redmine::Plugin.register :redmine_monthchart do
  name 'Redmine Monthchart plugin'
  author 'Cyrill Sizov'
  description 'Monthly spent time plugin for Redmine'
  version '0.0.3'

  menu :top_menu, :monthchart, { :controller => 'calendar', :action => 'index' }, :caption => 'Month Chart',
   :if => Proc.new{User.current.allowed_to?(:log_time, nil, :global => true)} 
end