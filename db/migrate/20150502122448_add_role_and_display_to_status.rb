class AddRoleAndDisplayToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :role, :integer, default: 0
    add_column :statuses, :display, :integer, default: 0
  end
end
