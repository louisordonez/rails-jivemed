class CreateJoinTableUserFee < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :fees do |t|
      # t.index [:user_id, :fee_id]
      # t.index [:fee_id, :user_id]
    end
  end
end
