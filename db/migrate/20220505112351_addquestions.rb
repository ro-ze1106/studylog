class Addquestions < ActiveRecord::Migration[6.1]
  def change
      add_column :questions, :user_id, :integer
      add_column :questions, :problem_id, :integer

      add_index :questions, [:user_id, :problem_id], unique: true
  end
end
