class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :customer_name
      t.string :email
      t.string :subject
      t.text :body
      t.string :slug
      t.integer :department_id
      t.integer :status_id, index: true
      t.integer :staff_id, index: true

      t.timestamps null: false
    end
  end
end
