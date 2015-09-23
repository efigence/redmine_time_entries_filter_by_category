require File.expand_path('../../test_helper', __FILE__)

class TimelogControllerTest < Redmine::IntegrationTest
  fixtures :projects, :enabled_modules, :roles, :members,
           :member_roles, :issues, :time_entries, :users,
           :trackers, :enumerations, :issue_statuses,
           :custom_fields, :custom_values,
           :projects_trackers, :custom_fields_trackers,
           :custom_fields_projects, :issue_categories

  def test_user_should_see_category_column
    log_user('admin', 'admin')
    get '/time_entries'
    assert_select 'td.category'
    assert_select "tr" do |elements|
      elements.each do |element|
        bidning.pry
      end
    end
  end
end