class AddUsernameToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :username, :string
    add_index :staffs, :username, unique: true
  end
end
