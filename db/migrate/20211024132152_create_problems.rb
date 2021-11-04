class CreateProblems < ActiveRecord::Migration[6.1]
  def change
    create_table :problems do |t|
      t.string :study_type
      t.string :picture
      t.text :problem_text
      t.text :answer
      t.text :problem_explanation
      t.string :target_age
      t.text :reference
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :problems, [:user_id, :create_at]
  end
end
