class AddEditorIdToTicketUpdate < ActiveRecord::Migration
  def change
    add_column :ticket_updates, :editor_id, :integer
    add_foreign_key :ticket_updates, :staffs, column: :editor_id
  end
end
