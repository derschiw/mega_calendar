require 'mega_calendar/filters.rb'
require 'vpim'
require_dependency 'mega_calendar/users_controller_patch'
require_dependency 'mega_calendar/issues_controller_patch'

Redmine::Plugin.register :mega_calendar do
  name 'Mega Calendar plugin'
  author 'Andreas Treubert'
  description 'Better calendar for redmine'
  version '1.8.0'
  url 'https://github.com/berti92/mega_calendar'
  author_url 'https://github.com/berti92'
  requires_redmine :version_or_higher => '4.0.0'
  menu(:top_menu, :calendar, { :controller => 'calendar', :action => 'index' }, :caption => :calendar, :if => Proc.new {(!Setting.plugin_mega_calendar['allowed_users'].blank? && Setting.plugin_mega_calendar['allowed_users'].include?(User.current.id.to_s) ? true : false)})
  menu(:top_menu, :holidays, { :controller => 'holidays', :action => 'index' }, :caption => :holidays, :if => Proc.new {(!Setting.plugin_mega_calendar['allowed_users'].blank? && Setting.plugin_mega_calendar['allowed_users'].include?(User.current.id.to_s) ? true : false)})
  settings :default => {'display_empty_dates' => 0, 'displayed_type' => 'users', 'displayed_users' => User.where(["users.login IS NOT NULL AND users.login <> ''"]).collect {|x| x.id.to_s}, 'default_holiday_color' => 'D59235', 'default_event_color' => '4F90FF', 'sub_path' => '/', 'week_start' => '1', 'allowed_users' => User.where(["users.login IS NOT NULL AND users.login <> ''"]).collect {|x| x.id.to_s}}, :partial => 'settings/mega_calendar_settings'
end

Rails.configuration.to_prepare do
  UsersController.send(:prepend, MegaCalendar::UsersControllerPatch)
  IssuesController.send(:prepend, MegaCalendar::IssuesControllerPatch)
end
