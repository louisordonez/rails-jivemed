class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.integer :available, default: 20

      t.timestamps
    end
  end
end
