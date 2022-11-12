class CreateDoctorFees < ActiveRecord::Migration[7.0]
  def change
    create_table :doctor_fees do |t|

      t.timestamps
    end
  end
end
