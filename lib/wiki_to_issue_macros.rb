require 'redmine'
require File.dirname(__FILE__) + '/../app/models/wiki_to_issue_ref.rb'

class WikiToIssueMacros
  unloadable

  def self.find_or_create_issue(object, args, scope = nil, switch = nil) 
    raise  "The correct usage is {{ issue(subject, [project])) }}" unless args.length >= 1

    #TODO: allow args to contain the issue ID too
    if args.length >= 2
      project = Project.find_by_identifier args[-1].strip
    end

    if project then
      args.delete_at(-1)
    else
      project = object.project
    end

    subject = args.join(', ')

    if wtir = WikiToIssueRef.find_by_subject_and_project_id(subject, project.id)
      # We've created an issue with this subject, and we've made the reference.
      # Now, if the subject of the issue changes, it doesn't mess with our link.
      link = scope["link_to_issue"].call wtir.issue
    else
      if issue = project.issues.find_by_subject(subject)
        # We've created an issue with this subject, so we should make a reference
        # to that issue so if its name changes we won't break the link in the future.
        wtir = WikiToIssueRef.new :subject => subject, :project => project, :issue => issue
        wtir.save!
        link = scope["link_to_issue"].call wtir.issue
      else
        # We haven't even created the issue yet, so we'll just show a link that will let us create it.

        if object.is_a? WikiContent 
          description =  "Issue originated from [["+object.project.identifier+":"+object.page.title+"]]"
        elsif object.is_a? Issue
          description =  "Issue originated from #" + object.id.to_s
        elsif object.is_a? Journal
          description =  "Issue originated from #" + object.journalized_id.to_s
        end
        url_args = { 
          :controller => "issues",
          :action => 'new', 
          :project_id => project, 
          :issue => {
            :subject => subject,
            :description => description,
            :priority_id => IssuePriority.default,
          }
        }

        link = scope["link_to"].call("Issue #____" , url_args, {:class => "new"}) 
        link << ": " + subject
      end
    end
    return link
  end
end
