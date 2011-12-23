class WikiToIssueRef < ActiveRecord::Base
  unloadable
  belongs_to :issue, :foreign_key=>:issue_id, :class_name=>"Issue"
  belongs_to :project, :foreign_key=>:project_id, :class_name => "Project"
  validates_uniqueness_of :subject, :scope => :project_id
end
