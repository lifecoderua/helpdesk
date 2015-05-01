class CreateTicketUpdates < ActiveRecord::Migration
  def change
    create_table :ticket_updates do |t|
      t.integer :ticket_id, index: true
      t.text :body
      t.integer :staff_id
      t.integer :status_id

      t.timestamps null: false
    end
  end
end
