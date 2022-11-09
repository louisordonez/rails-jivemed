class CreateFees < ActiveRecord::Migration[7.0]
  def change
    create_table :fees do |t|
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
