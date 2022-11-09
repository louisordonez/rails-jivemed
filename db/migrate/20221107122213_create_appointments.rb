class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.integer :amount
      t.integer :payment_method
      t.references :user, null: false, foreign_key: true
      t.references :schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
