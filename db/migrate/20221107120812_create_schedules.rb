class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.references :doctor, null: false, foreign_key: { to_table: :users }
      t.date :date
      t.timestamps
    end
  end
end
