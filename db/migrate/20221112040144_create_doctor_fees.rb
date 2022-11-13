class CreateDoctorFees < ActiveRecord::Migration[7.0]
  def change
    create_table :doctor_fees do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
