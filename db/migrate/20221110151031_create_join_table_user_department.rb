class CreateJoinTableUserDepartment < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :departments do |t|
      # t.index [:user_id, :department_id]
      # t.index [:department_id, :user_id]
    end
  end
end
