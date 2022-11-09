class RenameAppointmentsToReservations < ActiveRecord::Migration[7.0]
  def change
    rename_table :appointments, :reservations
  end
end
