class AddToCreateProblems < ActiveRecord::Migration[6.1]
  def change
    add_column :problems, :tatle, :string
    add_column :problems, :explanation_text, :string
  end
end
