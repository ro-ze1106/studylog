class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.integer :user_id
      t.integer :problem_id

      t.timestamps
    end
      add_index :questions, [:user_id, :problem_id], unique: true
    end
  end
end
