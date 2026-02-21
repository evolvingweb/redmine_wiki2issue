require 'redmine'

# Tell Zeitwerk to ignore this plugin's lib directory
plugin_lib = File.join(File.dirname(__FILE__), 'lib')
Rails.autoloaders.each { |loader| loader.ignore(plugin_lib) }

# Require plugin files
require File.join(plugin_lib, 'wiki_to_issue_macros')

Redmine::Plugin.register :redmine_wiki2issue do
  name 'Wiki2issue macro'
  author 'Evolving Web Inc'
  description 'Macro to create issues from within wiki pages.'
  version '6.0.0'
  author_url 'http://evolvingweb.ca'

  Redmine::WikiFormatting::Macros.register do
    desc = "Find or create issue in current project by subject (issue)"

    macro :issue do |obj, args|
      # these ApplicationHelper methods are accessible only in the current scope, so we pass them along
      # must provide default values for args
      scope = {
        "link_to" => Proc.new {|a,b,c| link_to( a,b || {},c || {})},
        "link_to_issue" => Proc.new {|a,b| link_to_issue( a, b || {})}
      }

      out = WikiToIssueMacros.find_or_create_issue(obj, args, scope)
    end
  end
end
