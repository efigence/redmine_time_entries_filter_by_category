Redmine::Plugin.register :redmine_time_entries_filter_by_category do
  name 'Redmine Time Entries Filter By Category plugin'
  author 'Author name'
  description 'This plugin lets users filter time entires by issue category.'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://efigence.com'
end
ActionDispatch::Callbacks.to_prepare do
  TimeEntryQuery.send(:include, RedmineTimeEntriesFilterByCategory::Patches::TimeEntryQueryPatch)
end