class CreateWikiToIssueRefs < ActiveRecord::Migration
  def self.up
    create_table :wiki_to_issue_refs do |t|
      t.column :subject, :string
      t.column :project_id, :integer
      t.column :issue_id, :integer
    end
  end

  def self.down
    drop_table :wiki_to_issue_refs
  end
end
