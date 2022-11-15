class AddAppointmentRefToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_reference :transactions, :appointment, null: false, foreign_key: true
  end
end
