class CreateUserTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email
      t.string :stripe_id
      t.decimal :amount, precision: 10, scale: 2
      t.string :receipt_url

      t.timestamps
    end
  end
end
