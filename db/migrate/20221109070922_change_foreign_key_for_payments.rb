class ChangeForeignKeyForPayments < ActiveRecord::Migration[7.0]
  def change
    rename_column :payments, :appointment_id, :reservation_id
  end
end
