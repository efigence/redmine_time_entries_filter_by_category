require_dependency 'time_entry_query'
require 'pry'
module RedmineTimeEntriesFilterByCategory
  module Patches
    module TimeEntryQueryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          
          alias_method_chain :initialize_available_filters, :categories
        end
      end
      module InstanceMethods

        def initialize_available_filters_with_categories
          initialize_available_filters_without_categories
          project = Project.find_by(id: project_id)
          add_available_filter "category_id",
            :type => :list,
            :values => selectable_categories(project)
        end

        def sql_for_category_id_field(field, operator, value)
          condition_on_id = sql_for_field(field, operator, value, IssueCategory.table_name, 'id')
          ids = value.map(&:to_i).join(',')
          table_name = IssueCategory.table_name
          if operator == '='
            "#{Issue.table_name}.category_id IN (#{ids})"
          else
            "#{Issue.table_name}.category_id NOT IN (#{ids})"
          end
        end

        private

        def selectable_categories(project=nil)
          scope = if project
                    project.issue_categories
                  else
                    IssueCategory.all
                  end
          scope.order("name ASC").pluck(:name, :id).map {|ic| ic.map(&:to_s)}
        end
      end
    end
  end
end
