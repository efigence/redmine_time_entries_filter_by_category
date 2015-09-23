require File.expand_path('../../test_helper', __FILE__)

class TimelogControllerTest < ActionController::TestCase
  fixtures :projects, :enabled_modules, :roles, :members,
           :member_roles, :issues, :time_entries, :users,
           :trackers, :enumerations, :issue_statuses,
           :custom_fields, :custom_values,
           :projects_trackers, :custom_fields_trackers,
           :custom_fields_projects, :issue_categories

  def test_filter_time_entries_by_category
    get :index, f: ["category_id", ""], op: {"category_id"=>"="}, v: {"category_id"=>["1"]}, 
                c: ["project", "spent_on", "user", "activity", "issue", "comments", "hours"]
    assert_equal 2, assigns(:entries).size, 'Wrong entries count, should equal 2'
    assigns(:entries).each do |entry|
      assert_equal 1, entry.issue.category_id, 'Wrong category_id'
    end
    assert_equal nil, assigns(:project), 'There should not be project'
  end

  def test_filter_project_time_entries_by_category
    get :index, f: ["category_id", ""], op: {"category_id"=>"="}, v: {"category_id"=>["1"]}, 
                c: ["project", "spent_on", "user", "activity", "issue", "comments", "hours"],
                project_id: Project.first.identifier
    assert_equal 2, assigns(:entries).size, 'Wrong entries count, should equal 2'
    assigns(:entries).each do |entry|
      assert_equal 1, entry.issue.category_id, 'Wrong category_id'
      assert_equal 1, entry.project_id, 'Wrong project_id'
    end
    assert_equal 1, assigns(:project).id, 'Wrong project'
  end
end